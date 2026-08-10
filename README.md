# BDSE12-Group3 — Home Credit Default Risk（放款違約風險分析）

> Term project of the **III Big Data engineer program (資策會 BDSE12 巨量資料分析就業養成班)**, 2019–2020. Team of 6 — I served as **team lead**.
>
> ⚠️ This repository is preserved **as-is** as a 2020 snapshot of my Data Science bootcamp capstone. Code style and tooling reflect that era, not my current practice — see [quant-trader](https://github.com/stansuo/quant-trader) and [crewai-factory](https://github.com/stansuo/crewai-factory) for recent work.

## TL;DR (English)

Predicting loan-applicant default risk on the Kaggle **[Home Credit Default Risk](https://www.kaggle.com/c/home-credit-default-risk)** dataset — a relational schema of 7 tables (2 branches × 3 levels; largest single table 122 columns / **27.3M rows**). EDA and feature engineering in Python (pandas / numpy); models: **LightGBM / XGBoost / Random Forest with Bayesian hyperparameter optimization**. Final result: **private-test AUROC 0.79780** (competition winner: 0.80570 — comparable to Kaggle silver-medal range). Heavy joins and aggregations ran on a **self-hosted 12-node Hadoop–YARN–Spark cluster** via PySpark.

## 專案簡介

以 Kaggle Home Credit Default Risk 資料集，從申貸人背景與信用行為資料預測違約機率，支援信貸決策與風險管理。資料為 7 張關聯表（2 分枝 × 3 層次），單一資料表最大 122 欄 / 2,730 萬列。

## 成果

- Private test **AUROC 0.79780**（該屆 Kaggle 冠軍 0.80570，成績約當 silver-medal 區間）
- 完整走過 資料分析 → 模型建置 → 資料平台 → 視覺化 四個 workstream

## 技術要點

- **EDA / Feature engineering**：pandas、numpy（`notebooks/homecdt_eda`、`notebooks/homecdt_fteng`）
- **模型**：LightGBM / XGBoost / Random Forest + Bayesian optimization 調參（`notebooks/homecdt_model`）
- **資料平台**：自架 **12-node Hadoop–YARN–Spark cluster**，以 PySpark 處理大表 join / aggregation（`docker/`、`shellcodes/`）
- 其他：R 分析腳本（`R_codes/`）

## 團隊與分工（My role）

6 人團隊結訓專題。我擔任**組長**，負責專案管理與整合，並實際參與全部四個 workstream（資料分析、模型建置、資料平台、視覺化）——包含組員卡關時 hands-on 一起 debug。本專題以共同學習為目的，程式碼由全組協作完成，不採嚴格模組分工。

## 文件與發表

- 專題文件（HackMD）：https://hackmd.io/@StanS/homecdt
- 成果發表影片：https://drive.google.com/file/d/13186YJbwVQpXS4lm-ANFHST1HEQ-aKzd/view
