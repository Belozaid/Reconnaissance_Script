# 🔍 Reconnaissance Script (AI-Enhanced)

> Automated Attack Surface Mapping & Intelligent Risk Analysis


## 📋 **Project Overview**

A comprehensive tool designed for cybersecurity experts and SOC analysts, combining the power of traditional reconnaissance tools with the precision of AI-powered analysis. The script automates the process of collecting data from digital assets (domains/IPs) and transforming raw data into actionable intelligence reports.

### ✨ Core Features

  * Intelligent Classification: Automatic classification of assets (Production, Staging, Dev, Admin) using AI.
  * Network Intelligence: A comprehensive examination of DNS, Ping, and Traceroute to determine the network structure.
  * Advanced Port Scanning: Service Version Detection using Nmap.
  * Vulnerability Mapping: Linking detected technologies to potential vulnerabilities.
  * Chronological Logging: Organizing results into dated folders for easy retrieval during Incident Response.

## 🚀 Getting Started
 Prerequisites
 
To ensure the tool functions efficiently, make sure the following tools are available in your environment:
  * PowerShell 5.1+: The primary engine for running scripts (pre-installed in Windows).
  * Nmap (7.9+): For port and service scanning. Download here.
  * Python 3.x: For the AI ​​data analysis engine. Download here.
  * 
### Installation & Setup

 1. Clone the repository
git clone https://github.com/Belozaid/Reconnaissance_Script.git

 2. Navigate to the project directory
cd Reconnaissance_Script

 3. Set Execution Policy (If needed)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

## 🛠️ Workflow (How it Works)

1. Phase 1 (Data Collection): Subdomains are collected, and ports and services are scanned.
2. Phase 2 (Enrichment): HTTP headers and web technologies (Tech Stack) are extracted.
3. Phase 3 (AI Analysis): Data is analyzed using the GPT engine to identify high-value attack targets.
4. Phase 4 (Reporting): A Markdown report containing security recommendations is generated.


## 📂 Project Structure

Reconnaissance_Script/
│
├── recon_script.ps1                   # Main script
├── README.md                            # Profile and Information
├── .gitignore                           # To ignore unwanted files
├── results/                              # A folder for the results (Git will ignore it)
├── screenshots/                          # Screenshot folder
