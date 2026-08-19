# P1 技术规格书 v3（定稿版）· RehabMedApp

> 状态：**v3 定稿**。第四轮问答锁定第二组/Q37/Q38；第一组(Q30/31/32)与 Q36 产品方暂无法答 → 采用架构师默认（标"待真实数据替换"）。可直接按「实作顺序」开刀。
> 范围：储存层 + 专家端展示层。居家康复运动数据由**外部项目分析**，本 App **不做再计算**。

---

## 0. 范围与定位
- App = **储存层 + 专家端展示层**。数据由外部项目分析，本 App 只负责"存好 + 给专家看漂亮 + 纵向对比"。
- **P1 交付**：储存 + 汇入（demo 路径）+ 专家仪表板（核心）+ 审计 + 安全锁 + 长者模式框架。
- **患者端**（上传档案 / 看回复 / 沟通 / 媒体模糊）列入 **P2**。

## 1. 系统形态
- **P1：纯本地离线 App，无后端**，装在**个人设备**（非诊所共用）。
- 预留后端接口（phase 2 接）：`RehabDataSource`(Api 桩) / `SyncService`(桩) / `NotificationService.registerPush`(桩)。
- Phase 2：后端 + API 拉取 + 跨设备同步 + 真推送。
- **跨设备同步冲突处理**：Q20 要同步、Q13 说离线 → 折中：**P1 单设备本地，预留 `SyncService` 接口**，phase 2 有后端时接上。

## 2. 角色 / 绑定 / 主题
- **医生(专家)**：临床洁净风（白/浅灰、医疗蓝绿、克制留白）；平板/网页优先（个人大屏）、鼠标；**生产环境只查看**。
- **患者**：温暖关怀风（柔和暖色、大圆角）；手机；上传档案 + 看专家回复 + 沟通（P2）。
- **绑定**：患者**同一时间只绑 1 专家**；1 专家 N 患者；专家看绑定患者**全部**数据。RBAC 按绑定隔离（非诊所共享）。
- **双主题**：`expert_theme` / `patient_theme`（角色感知 Design Token）。
- ⚠️ 对原项目规则"mobile-first"的例外：专家端**大屏优先**，手机仅轻量伴随视图；患者端仍手机优先。

## 3. 数据驱动（关键架构决策）
- 外部项目**真实输出字段未知**（Q15/16 暂缺样例）→ 仪表板**不写死指标**，做成 **schema 无关 / 数据驱动**。
- `ImportContract` 规范形状（**v3 采用架构师默认 Metric 结构，待真实格式对齐**）：
  - 快照含 `patientId / testDate / batchId / metrics[]`，**可选 `summary` 块**（见 Q31）。
  - 每条 `Metric`：`{ key, label, value, unit, kind, category?, referenceRange?, status?, series?[] }`
    - `kind`: `percentage`|`numeric`|`score`|`enum` → 决定图型
    - `category`: 雷达图分组（多指标平衡）
    - `referenceRange {low,high,normalLow,normalHigh}` / `status: normal|warning|abnormal` → 风险红绿、异常标红
    - `series[]`: `TrendPoint` 时序点（纵向对比）
- 仪表板据 `kind`/`category`/`series` 自动选图：
  - `percentage`/`score` → 仪表盘 ｜ `numeric`+`series` → 折线(趋势) ｜ `category` → 柱图/分布 ｜ 多 `series` 同屏 → 雷达 ｜ 依从性×时段 → 热力图
- **概览(summary)来源（Q31 默认 A）**：优先渲染外部给的 `summary` 块（completionRate/trend/risk 等高层字段，**严守不计算原则**）；若数据未含 summary，概览卡**优雅降级**为"最近一批指标列表 + 状态标色"，不自行计算比率。
- 汇入校验：`patientId / testDate / metrics` 必填；未知字段原样保留（`ext` 字典）。

## 4. 数据模型（freezed + json，全脱敏/PII 加密）
```dart
// patient_profile.dart —— PII，静态加密
@freezed
class PatientProfile with _$PatientProfile {
  const factory PatientProfile({
    required String patientId,     // 匿名内部识别码（非真实身份证）
    required String displayName,   // 展示用（Q7 含姓名）
    required DateTime dateOfBirth, // 出生年月
    required double heightCm,
    required double weightKg,
    required String rehabStage,
    required String expertId,      // 绑定专家（1:1 at a time）
    required bool isActive,
  }) = _PatientProfile;
}

// metric.dart —— 数据驱动的核心（v3 默认结构，待真实格式对齐）
enum MetricKind { percentage, numeric, score, enumeration }
enum MetricStatus { normal, warning, abnormal }

@freezed
class ReferenceRange with _$ReferenceRange {
  const factory ReferenceRange({
    required double low,
    required double high,
    double? normalLow,
    double? normalHigh,
  }) = _ReferenceRange;
}

@freezed
class Metric with _$Metric {
  const factory Metric({
    required String key,
    required String label,
    required MetricKind kind,
    required double value,
    required String unit,
    String? category,              // 雷达图分组
    ReferenceRange? referenceRange,
    MetricStatus? status,          // 外部若直接给最佳
    @Default(<TrendPoint>[]) List<TrendPoint> series, // 该指标时序点（纵向对比）
    Map<String, dynamic>? ext,
  }) = _Metric;
}

// rehab_snapshot.dart —— 已分析输出包（本 App 不计算）
enum RehabRisk { low, medium, high }
@freezed
class SnapshotSummary with _$SnapshotSummary { // 概览块（Q31，可选）
  const factory SnapshotSummary({
    double? completionRate,
    String? trendDirection,         // 'up'|'down'|'flat'
    RehabRisk? riskLevel,
    String? note,
  }) = _SnapshotSummary;
}
@freezed
class RehabSnapshot with _$RehabSnapshot {
  const factory RehabSnapshot({
    required String patientId,
    required String batchId,        // 对应 import_batch
    required DateTime testDate,     // 测试/评估日期（纵向对比关键）
    required List<Metric> metrics,  // 数据驱动：有什么画什么
    SnapshotSummary? summary,       // 可选概览块（无则降级，不计算）
  }) = _RehabSnapshot;
}

// trend_point.dart —— 同病人不同时间测试点（Q9 核心）
@freezed
class TrendPoint with _$TrendPoint {
  const factory TrendPoint({
    required DateTime at,
    required double value,
    required String metricKey,
  }) = _TrendPoint;
}

// media_asset.dart —— 模糊处理后的辅助影像/影片（P2 填充）
@freezed
class MediaAsset with _$MediaAsset {
  const factory MediaAsset({
    required String assetId,
    required String patientId,
    required MediaKind kind,        // image / video
    required String storagePath,    // 已模糊、已加密
    required DateTime capturedAt,
    required bool backgroundBlurred,
    required bool faceBlurred,
  }) = _MediaAsset;
}

// import_batch.dart —— 汇入溯源
@freezed
class ImportBatch with _$ImportBatch {
  const factory ImportBatch({
    required String batchId,
    required String sourceFileName,
    required ImportFormat format,   // json / csv / unknown
    required DateTime importedAt,
    required int recordCount,
  }) = _ImportBatch;
}

// audit_entry.dart —— 存取审计（Q18）
@freezed
class AuditEntry with _$AuditEntry {
  const factory AuditEntry({
    required String actorId,    // 谁
    required String patientId,  // 看了谁
    required String action,     // view/import/delete/export
    required DateTime at,
  }) = _AuditEntry;
}
```

## 5. 储存契约
- **加密盒**（hive + `encrypt`，密钥存 `secure_storage`）：`patients` / `snapshots`(按 batchId) / `media` / `meta`(batch+删除标记) / `audit`。
- **完整历史本地留存**（纵向对比）；`DeletionService` 软删(`isActive=false`) + `purge()` 硬删；**保留政策后补，销毁开关预留**。
- `RehabDataSource` 抽象；`FileImportDataSource`（弹性解析 + JSON 适配器，CSV 后补）；`ApiDataSource` 桩。

## 6. 汇入流程（P1 demo 路径）
- 汇入向导：选档(`file_picker`) → 侦测格式 → 弹性解析(→规范形) → 校验 → 写本地(加密) → **本机通知**。
- **生产 ingestion（Q38 澄清）**：汇入的本质是**患者在患者端自己上传**原始/分析数据 → (外部项目分析 + phase2 后端) → **专家查看数据并给出反馈**。即数据流的终点是专家看板。
- **P1 demo 边界**：患者端(P2)尚未实作，故 P1 用汇入向导在**专家设备直接载入"已分析好"的文件**来演示同样的 loading→storage→dashboard 路径；不出现患者上传 UI。生产接入患者上传/API 时复用同一 `RehabDataSource` 载入路径。

## 7. 专家仪表板（固定精致布局）
- 布局**固定**，不自定义（Q29）。大屏优先、responsive。
- 左：绑定患者列表（点选切换，RBAC 已隔）。
- 右：概览卡列(**data-driven** 摘要) → **纵向趋势图**(同病人多批次折线) → 下钻 Tab：
  - 运动分布(柱图) ｜ 历次测试(列表，可选两批次对比) ｜ 辅助媒体(模糊缩图，P2 填充)。
- 图表：折线/柱/雷达/仪表盘/热力图，按数据自动选（Q21）。

## 8. 通知
- P1：**仅本机通知**（汇入完成 / 删除 / 更新），`flutter_local_notifications`；`registerPush` 预留。
- Phase 2：真推送。

## 9. 审计（Q35 = A，不另设 Admin 角色）
- `AuditEntry` 存本地 `audit` 盒；**App 内审计查看页**：专家可看**自己绑定患者**的审计（谁/何时/看了谁/汇入/删除）。
- 不设第三 Admin 角色（保留政策与审计均由专家侧处理，最小权限）。

## 10. 安全锁（Q28=A，Q34=A 细化）
- **复用登录生物辨识**：切回前台 / 超时后**重验**（不另设独立锁）。
- **超时可配，默认 3 分钟**；锁**整个 App**（进任意页前先验证）。
- 实现：`local_auth` 生物辨识 + 可选密码兜底；PII 静态加密。

## 11. 长者模式（Q25=C，Q33=A 细化「两端语义不同」）
- **触发逻辑分端**（Q33 关键）：
  - **专家端**：按**用家（专家本人）年龄**判断 → 满 65 自动套用 + 可手动覆盖。
  - **患者端**：按**病患年龄**判断 → 满 65 自动套用 + 可手动覆盖。
- 可调：**字号 / 高对比 / 简化导航**（两端均提供）。
- `expert_theme` 与 `patient_theme` 均支持长者参数。

## 12. 合规处理
- **PDPO**：PII 静态加密、同意 UX(P2 上传时补)、保留开关、审计日志；eHealth 插槽预留；**不跨病人对比**；数据最小化。
- **媒体**：存前模糊背景 + 面部（`media_blur`，P2 实作，P1 留接口）。

## 13. 依赖增补
`file_picker`、`flutter_local_notifications`、`local_auth`(+密码)、`hive`+`encrypt`(已有)、`fl_chart`(已有)、`freezed`/`riverpod`/`go_router`(已有)。

## 14. 实作顺序（P1 任务）
1. 模型层（PatientProfile/Metric/RehabSnapshot/TrendPoint/MediaAsset/ImportBatch/AuditEntry）+ regen
2. 储存层（加密盒 / DeletionService / RehabDataSource+FileImport+Api 桩 / ImportContract+JSON 适配器 / AuditStore）
3. 汇入向导 UI
4. 专家仪表板（data-driven 卡 + 图 + 历史 + 媒体桩）
5. 通知骨架（本机）
6. 审计查看页
7. 安全锁（前台重验）
8. 长者模式（自动 + 手动 + 可调）
9. 角色感知双主题
10. 接线（router 加 `/import`、dashboard 接 repository、main 初始化）
11. l10n 补键 + `build_runner` + `analyze` 自检

## 15. v3 默认决策（第一组 Q30/31/32 与 Q36 产品方暂无法答 → 架构师默认，标"待真实数据替换"）
- **Q30 Metric 结构**：采用 `{key,label,value,unit,kind,category?,referenceRange?,status?,series?[]}`（见 §3/§4）。**待真实格式对齐**。
- **Q31 概览来源**：默认外部提供 `summary` 块；无则降级概览（不计算）。**待真实数据确认**。
- **Q32 Demo 数据**：P1 由我**自拟脱敏 demo JSON**（3–5 患者、多批次、覆盖 gauge/折线/柱/雷达/热力 各 kind）作"样例契约 + 演示种子"，App 内置可一键载入。**待真实样例替换**。
- **Q36 汇入格式**：**JSON 优先**（写 JSON 适配器）+ App **内置样例种子一键载入**；CSV 适配器留桩。
- 其余待定：保留政策（销毁开关已留）、患者上传/媒体模糊/沟通（P2）、跨设备同步（phase2）。

## 16. 验收标准
专家汇入样例 JSON → 患者入列表 → 看板见 **data-driven** 概览 + 纵向趋势 → **离线重开仍在** → 删除软删可查审计 → 前台切回需生物锁 → 开长者模式字号/对比变化 → 本机通知到达。
