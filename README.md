# PH Plausibility Reports

R scripts and resources for generating **data quality and plausibility reports** on three public health indicator groups:

- **Mortality**
- **Food Security & Livelihoods (FSL)**
- **Mid-Upper Arm Circumference (MUAC)**

These tools are designed to identify issues in raw survey data and support feedback loops to field teams.

---

## 🚀 Getting Started

1. Clone or download the repository:

   ```bash
   git clone https://github.com/ig-impact/PH_plausibility_reports
   ```
For Rstudio specific instructions follow these steps:

![Cloning an existing GitHub project in RStudio](https://argoshare.is.ed.ac.uk/healthyr_book/images/chapter14/7.png)

*Figure: Screenshot from the [HealthyR Book – Cloning an Existing GitHub Project to a New RStudio Project](https://argoshare.is.ed.ac.uk/healthyr_book/clone-an-existing-github-project-to-new-rstudio-project.html), used with attribution.*

2. Open the project in **RStudio**

3. Restore the environment:

   ```r
   renv::restore()
   ```

4. Place your raw `.xlsx` dataset(s) in the appropriate `inputs/` folder inside one of the report directories (`muac_quality_report`, `fsl_quality_report`, or `mortality_quality_report`).

5. Open the corresponding script starting with `standalone_` and run it in **RStudio**. This will generate the report in `output/reports/`.

---

## 📁 Project Structure (simplified)

```
.
├── R/
│   ├── utility functions (*.R)
├── fsl_quality_report/
│   ├── standalone_fsl_quality_html_report.R
│   ├── fsl_quality_report_markdown.Rmd
│   ├── inputs/
│   │   └── DATASET.xlsx
│   ├── reports/
├── mortality_quality_report/
│   ├── standalone_mort_quality_report.R
│   ├── quality_report_draft.Rmd
│   ├── inputs/
│   │   └── DATASET.xlsx
│   ├── reports/
├── muac_quality_report/
│   ├── standalone_muac_quality_html_report.R
│   ├── muac_quality_report_markdown.Rmd
│   ├── inputs/
│   │   └── DATASET.xlsx
│   ├── reports/
└── renv.lock
```

---

## 🧪 How to Use

You do **not** knit the `.Rmd` files directly.

Instead, you run the corresponding script to generate the HTML report. For example:

### MUAC

1. Place your dataset in `muac_quality_report/inputs/`
2. Open `muac_quality_report/standalone_muac_quality_html_report.R` in RStudio
3. Adjust the parameters at the top of the script (e.g., file name, sheet name, variables)
4. Run the script — output goes to `muac_quality_report/output/reports/`

### FSL

Same steps using:

- Script: `fsl_quality_report/standalone_fsl_quality_html_report.R`
- Input folder: `fsl_quality_report/inputs/`

### Mortality

Same steps using:

- Script: `mortality_quality_report/standalone_mort_quality_report.R`
- Input folder: `mortality_quality_report/inputs/`

---

## 🐞 Reporting Issues

To report bugs or suggest features:

1. Go to the [Issues tab](https://github.com/ig-impact/PH_plausibility_reports/issues)
2. Click **New issue**
3. Choose **Bug Report** or **Feature Request**
4. Describe the problem clearly:  
   - What were you trying to do?  
   - What happened instead?  
   - Any error messages or screenshots?

We review issues regularly and will follow up as needed.
