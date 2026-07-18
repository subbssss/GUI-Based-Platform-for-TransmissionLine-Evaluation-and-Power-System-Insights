# GUI-Based-Platform-for-TransmissionLine-Evaluation-and-Power-System-Insights
An interactive MATLAB-based graphical platform for evaluating transmission line parameters, analyzing power system performance, estimating transmission losses, calculating conductor ampacity, and assessing transmission line severity under different operating conditions.

---

# Abstract

Accurate evaluation of transmission line parameters is essential for designing reliable and efficient electrical power systems. Parameters such as resistance, inductance, capacitance, efficiency, voltage regulation, conductor ampacity, and transmission losses directly influence the operational performance of overhead transmission networks. Traditional analytical approaches require lengthy manual calculations and separate computational tools, making them less suitable for rapid design analysis and educational applications.

This project presents a comprehensive **MATLAB Graphical User Interface (GUI)** that integrates multiple transmission line analysis modules into a single interactive platform. The application enables users to calculate transmission line parameters from user-defined conductor and tower configurations, estimate efficiency and voltage regulation for short, medium, and long transmission lines, evaluate multiple loss mechanisms, compute conductor ampacity, and determine fault severity using a severity index.

By combining analytical calculations with graphical visualization, the developed GUI provides a simple yet powerful environment for engineers, students, and researchers to analyze transmission line behaviour without requiring extensive MATLAB programming knowledge.

---

## Table of Contents

- [Abstract](#abstract)
- [Key Features](#key-features)
- [Software Used](#software-used)
- [Repository Structure](#repository-structure)
- [GUI Modules](#gui-modules)
- [Working Principle](#working-principle)
- [Transmission Line Parameters](#transmission-line-parameters)
- [Transmission Line Performance Analysis](#transmission-line-performance-analysis)
- [Mathematical Background](#mathematical-background)
- [Important Derivations](#important-derivations)
- [MATLAB File Structure](#matlab-file-structure)
- [Workflow](#workflow)
- [GUI Screenshots](#gui-screenshots)
- [Results](#results)
- [Validation](#validation)
- [Applications](#applications)

---

# Key Features

- Interactive MATLAB GUI for transmission line analysis
- Automatic computation of Resistance (R), Inductance (L) and Capacitance (C)
- Support for multiple conductor materials and tower configurations
- Evaluation of Short, Medium and Long transmission line models
- Voltage Regulation and Transmission Efficiency calculation
- Transmission Loss Distribution Analysis
- Ampacity Suitability Calculator
- Fault Severity Index Estimation
- Real-time graphical visualization of computed parameters
- Modular MATLAB implementation for future research and customization

---

# Software Used

| Software | Purpose |
|-----------|---------|
| MATLAB | GUI Development and Numerical Computation |
| MATLAB App Designer / GUIDE | Graphical User Interface Development |
| MATLAB Scripts (.m) | Analytical Computations |
| GitHub | Version Control and Project Documentation |

---

# Repository Structure

```text
GUI-Based-Transmission-Line-Evaluation/

│
├── matlab_files/
│      ├── TransmissionLineApp.m
│      ├── AmpacityGUI.m
├── Reports
       ├── Validation.pdf
       ├── Report.pdf
├── README.md
```

---

# GUI Modules

The developed platform consists of several independent analytical modules integrated into a single graphical environment. Each module focuses on a specific aspect of transmission line design and performance evaluation while sharing computed electrical parameters with the remaining sections of the software.

| Module | Purpose |
|---------|----------|
| Transmission Line Parameter Evaluation | Calculates Resistance, Inductance and Capacitance from conductor specifications |
| Performance Analysis | Computes efficiency and voltage regulation using appropriate transmission line models |
| Loss Distribution | Evaluates different electrical losses and their influence on transmission efficiency |
| Ampacity Calculator | Estimates conductor current carrying capability under specified environmental conditions |
| Severity Index | Determines transmission system performance degradation during fault conditions |

---

# Working Principle

The user begins by entering conductor specifications, tower geometry, transmission line length, operating temperature, conductor material, frequency, and other required electrical parameters through the graphical interface. The software processes these inputs using analytical transmission line equations to calculate the primary line constants (R, L and C), which subsequently become the basis for all remaining calculations.

Once the electrical parameters are obtained, the GUI evaluates transmission efficiency, voltage regulation, conductor ampacity, transmission losses, and fault severity. All calculated results are presented through numerical outputs, tables, and graphical plots, allowing users to compare different conductor configurations and transmission line models within a single integrated environment.

---

# Transmission Line Parameters

The first module of the proposed GUI evaluates the fundamental electrical parameters of an overhead transmission line based on the physical geometry and conductor characteristics provided by the user. Since every subsequent calculation—including efficiency, voltage regulation, power loss, ampacity, and fault analysis—depends on these parameters, this module forms the foundation of the entire application.

The GUI accepts user inputs such as conductor material, conductor diameter, operating temperature, conductor spacing, tower configuration, number of circuits, and transmission line length. Based on these values, the software automatically computes the transmission line resistance (R), inductance (L), and capacitance (C) using standard analytical equations.

The module supports multiple tower configurations including Delta, Horizontal, Vertical, and Hexagonal arrangements, together with single and double circuit transmission lines. This enables engineers to compare various conductor layouts and identify the most suitable configuration for a particular transmission system.

---

## User Inputs

| Parameter | Description |
|------------|-------------|
| Conductor Material | Copper, Aluminium, ACSR, AAAC, etc. |
| Operating Temperature | Used for temperature-dependent resistance calculation |
| Conductor Diameter | Physical conductor diameter |
| Number of Bundles | Number of sub-conductors per phase |
| Bundle Spacing | Distance between bundled conductors |
| Tower Configuration | Delta, Horizontal, Vertical, Hexagonal |
| Number of Circuits | Single / Double Circuit |
| Transmission Line Length | Length of the transmission line |

---

## Parameters Computed

| Output | Unit |
|---------|------|
| Resistance (R) | Ω/km |
| Inductance (L) | mH/km |
| Capacitance (C) | nF/km |
| Geometric Mean Radius (GMR) | m |
| Geometric Mean Distance (GMD) | m |

---

# Transmission Line Performance Analysis

Once the line constants are obtained, the GUI evaluates the electrical performance of the transmission line by selecting the appropriate mathematical model according to its length. The software automatically distinguishes between short, medium, and long transmission lines, ensuring that the corresponding transmission line equations are used for analysis.

The application calculates sending-end and receiving-end quantities, determines voltage regulation, estimates transmission efficiency, and provides a visual comparison between ideal operating conditions and practical operating conditions after accounting for transmission losses.

---

## Supported Transmission Line Models

| Line Type | Length |
|------------|--------|
| Short Transmission Line | Less than 80 km |
| Medium Transmission Line | 80 km – 250 km |
| Long Transmission Line | Greater than 250 km |

---

## Performance Parameters

| Quantity | Description |
|----------|-------------|
| Sending End Voltage | Voltage at the source |
| Receiving End Voltage | Voltage at the load |
| Sending End Current | Current supplied by the source |
| Receiving End Current | Current received at the load |
| Voltage Regulation | Percentage voltage variation |
| Transmission Efficiency | Ratio of output power to input power |

---

## Performance Equations

### Voltage Regulation

[VR={V_s-V_r}/{V_r}*100]

where

- (V_s) = Sending End Voltage
- (V_r) = Receiving End Voltage

---

### Transmission Efficiency

[eta={P_{out}}/{P_{in}}*100]

where

- (P_{out}) = Receiving End Power
- (P_{in}) = Sending End Power

---

# Mathematical Background

The GUI is entirely based on analytical transmission line equations commonly used in power system analysis. Instead of requiring users to manually evaluate each expression, the developed platform performs every intermediate calculation internally and presents only the final engineering results through an intuitive graphical interface.

The calculations begin with conductor geometry, from which the Geometric Mean Radius (GMR) and Geometric Mean Distance (GMD) are obtained. These values are then used for computing inductance and capacitance. Temperature-corrected resistance is subsequently evaluated before the software proceeds to performance analysis, loss estimation, ampacity computation, and fault severity assessment.

---

## Resistance Calculation

The resistance of the conductor varies with temperature and is calculated using

[R_T=R_{20}[1+alpha(T-20)]]

where

| Symbol | Meaning |
|---------|----------|
| (R_T) | Resistance at operating temperature |
| (R_{20}) | Resistance at 20°C |
| (alpha) | Temperature coefficient of resistance |
| (T) | Operating temperature |

---

## Inductance Calculation

The inductance per conductor is calculated as

[L=2*10^{-7}ln({GMD}/{GMR});H/m]

which is automatically converted into practical engineering units for display inside the GUI.

---

## Capacitance Calculation

The capacitance of the transmission line is determined using

[C={2pi*varepsilon}/{ln(GMD/GMR)}]

where

- (varepsilon) represents the permittivity of the surrounding medium.

---

# Important Derivations

The project incorporates several mathematical derivations that were implemented directly into the MATLAB GUI for cases where standard closed-form equations were either unavailable or required modification to support different transmission line geometries.

These derivations allow the software to support symmetric and asymmetric conductor configurations while maintaining computational accuracy for practical transmission line layouts.

---

## Geometric Mean Distance (GMD)

The Geometric Mean Distance is obtained as

[GMD=sqrt[3]{D_{AB}*D_{BC}*D_{CA}}]

where

- (D_{AB})
- (D_{BC})
- (D_{CA})

represent the equivalent spacing between the individual phase conductors.

---

## Ampacity Utilization Factor

The conductor utilization factor is calculated as

[U= {I_{max}}/{I_{ampacity}}]

where

- (I_{max}) = Maximum operating current
- (I_{ampacity}) = Allowable conductor current

The obtained utilization factor forms the basis for the ampacity suitability score presented by the GUI.

---

## Severity Index

The severity index estimates the degradation in transmission line performance during fault conditions and is calculated as

[Severity Index= 1-{eta_{fault}}/{eta_{normal}}]

A higher severity index indicates a greater reduction in transmission efficiency and therefore a more severe operating condition.

---

# MATLAB File Structure

The application follows a modular MATLAB implementation where each analytical component is implemented independently to simplify future modification and maintenance.

| MATLAB File | Description |
|-------------|-------------|
| main_GUI.m | Main graphical user interface |
| parameter_calculation.m | Resistance, inductance and capacitance calculations |
| performance_analysis.m | Voltage regulation and efficiency |
| loss_distribution.m | Power loss estimation |
| ampacity_calculator.m | Ampacity suitability computation |
| severity_index.m | Fault severity estimation |
| helper_functions.m | Supporting mathematical functions |

> Replace the filenames above with the actual MATLAB scripts uploaded in the repository.

---

# Workflow

<p align="center">
  
<img width="1196" height="446" alt="image" src="https://github.com/user-attachments/assets/41062dc7-7215-49d7-993f-81bd1326740a" />

</p>
<b>Figure 2.</b> Overall Workflow of the Proposed MATLAB GUI

---

# GUI Screenshots

The developed MATLAB application combines multiple analytical modules into a single interactive graphical interface. Instead of requiring separate scripts for parameter estimation, performance analysis, and conductor evaluation, every module is integrated within a unified GUI. The interface enables users to modify input parameters, instantly visualize results, and compare different transmission line configurations without manually editing MATLAB code.

---

## Complete GUI

<p align="center">
<img width="524" height="279" alt="image" src="https://github.com/user-attachments/assets/323819d7-6ef2-49f1-9181-71367e1030c6" />
</p>

<p align="center">
<b>Figure 3.</b> Complete MATLAB GUI Platform
</p>

The main GUI serves as the central workspace of the application. It allows users to provide transmission line specifications, choose different analysis modules, visualize numerical outputs, and observe graphical plots generated during the computation process. The integrated design eliminates the need for switching between multiple scripts while improving usability and reducing computational complexity.

---


## Loss Distribution Analysis

<p align="center">
  <img width="276" height="280" alt="image" src="https://github.com/user-attachments/assets/34f3ee26-6d64-49a6-a5ec-8a0442d1d0c8" />

  <img width="271" height="278" alt="image" src="https://github.com/user-attachments/assets/9b9d2b2e-8a86-4481-a4ce-05c4dd69221d" />

  <img width="262" height="252" alt="image" src="https://github.com/user-attachments/assets/9e255625-2c23-488c-b27e-40d9896295d2" />
</p>

<p align="center">
<b>Figure 6.</b> Transmission Line Loss Distribution
</p>

The GUI estimates the contribution of different electrical losses affecting the transmission system. Users can enable or disable individual loss components to observe their influence on the overall efficiency of the transmission line. This enables engineers to identify dominant loss mechanisms and optimize conductor selection accordingly.

---

## Ampacity Suitability Calculator

<p align="center">
<img width="357" height="405" alt="image" src="https://github.com/user-attachments/assets/be8944df-c0b1-427d-afa8-ad1a8bb552a3" />
</p>

<p align="center">
<b>Figure 7.</b> Ampacity Suitability Calculator
</p>

The ampacity module evaluates the current carrying capability of the selected conductor by considering conductor dimensions together with environmental conditions such as ambient temperature, wind speed, and conductor operating temperature. A weighted scoring algorithm provides a suitability score that indicates whether the selected conductor operates safely within its thermal limits.

---

# Results

The developed MATLAB platform successfully integrates multiple transmission line analysis techniques into a single graphical environment. The obtained numerical results demonstrate that the proposed implementation accurately evaluates conductor parameters, transmission performance, loss distribution, and conductor ampacity while providing intuitive graphical visualization for engineering analysis.

The developed GUI was tested under multiple conductor configurations, transmission line lengths, and operating temperatures. The obtained results closely follow theoretical expectations and validate the correctness of the implemented mathematical models.

---

## Resistance Validation

The temperature-dependent resistance calculations demonstrate the expected increase in conductor resistance with increasing operating temperature. Copper conductors exhibit lower resistance than aluminium conductors for identical dimensions, validating the correctness of the implemented temperature correction equations.

<p align="center">
<img width="432" height="337" alt="image" src="https://github.com/user-attachments/assets/bbc5f840-f634-4388-a6e4-d28201c12f36" />
</p>

<p align="center">
<b>Figure 8.</b> Resistance Calculation Results
</p>

---

## Inductance and Capacitance Evaluation

The calculated inductance and capacitance values vary according to conductor spacing, tower geometry, and the number of bundled conductors. The obtained values remain within practical engineering ranges and closely match standard transmission line calculations.

<p align="center">
<img width="393" height="607" alt="image" src="https://github.com/user-attachments/assets/76e1cd2d-94ea-47d5-9d9d-0e87f935e6c7" />
</p>

<p align="center">
<b>Figure 9.</b> R-L-C Parameter Evaluation
</p>

---

# Validation

The analytical equations implemented in the GUI were validated using representative transmission line cases. The computed resistance, inductance, and capacitance values closely agree with theoretical calculations, demonstrating a maximum deviation of less than **5%**, thereby confirming the numerical accuracy of the developed platform. :contentReference[oaicite:0]{index=0}

## Quantitative Validation

| Parameter | GUI Value | Reference Value | Percentage Error |
|------------|----------:|----------------:|-----------------:|
| Resistance | 3.50396 Ω | 3.51 Ω | 0.17% |
| Inductance | 0.9866 mH/km | 1.00 mH/km | 1.34% |
| Capacitance | 11.571 nF/km | 12.00 nF/km | 3.58% |

The obtained error values demonstrate excellent agreement with theoretical calculations and verify the reliability of the proposed MATLAB GUI for transmission line analysis. 

---

# Applications

- Transmission line design and parameter estimation
- Power system performance evaluation
- Conductor selection and comparison
- Voltage regulation analysis
- Transmission efficiency estimation
- Educational laboratories for Power Systems
- Research involving overhead transmission lines
- Ampacity assessment under varying environmental conditions
- Electrical utility planning and preliminary design studies
- Academic demonstration of transmission line modelling
