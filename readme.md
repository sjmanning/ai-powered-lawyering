# README - AI-Powered Lawyering: Anonymized Replication Package

## Overview
This repository contains the anonymized data and analysis code for the AI-Powered Lawyering study, which examines the performance effects of AI tools (Vincent and GPT o1-preview) on law students completing various legal tasks. All personally identifiable information (PII) has been removed.

This replication package accompanies the paper:
Schwarcz, Daniel and Manning, Sam and Barry, Patrick James and Cleveland, David R. and Prescott, J.J. and Rich, Beverly, "AI-Powered Lawyering: AI Reasoning Models, Retrieval Augmented Generation, and the Future of Legal Practice" (March 02, 2025). Minnesota Legal Studies Research Paper No. 25-16, Available at SSRN: https://ssrn.com/abstract=5162111 or http://dx.doi.org/10.2139/ssrn.5162111

## Configuration
Before running any notebooks, modify the `config.py` file to set the `master_folder` path to your local repository directory.

## Workflow
To reproduce the results:
1. Run **anonymized_analysis.ipynb** for the main analysis of productivity, task scores, and differential effects by student GPA
2. Optionally run **outlier_sensitivity_analysis.ipynb** for additional robustness checks (not required for main findings)

## Key Data Files
This repository includes anonymized versions of these data files:
- "Time Spent on Assignments" (anonymized)
- "Group Assignments" (anonymized)
- "Grading Sheets" for Problems 1-6 (anonymized)
- "Enrolled Participants" information (anonymized)
- Anonymized Qualtrics survey data:
  - Enrollment survey with student background information
  - Post-completion survey with self-reported AI tool effectiveness

## Data Anonymization Details
All personally identifiable information has been removed through the following process:
- Participant names and emails replaced with hashed anonymous IDs
- Location data (IP addresses, coordinates) completely redacted
- Survey responses from non-participants fully redacted
- Consistent anonymous IDs used across all data files to maintain relational integrity

## Output Files
The analysis notebooks generate:
- .tex tables for publication (treatment effects, balance tables, etc.)
- .csv data files with results

Each run of the analysis will create a new working folder with timestamped results in the analysis/data directory.