# Import Debugging Notes

## Problem

While importing the Superstore dataset into MySQL using MySQL Workbench Import Wizard, only 145 rows were imported instead of the complete dataset.

## Investigation

* Verified dataset structure in Excel.
* Checked CSV formatting.
* Examined table schema.
* Investigated SQL modes.
* Analyzed import logs.
* Tested different import methods.

## Solution

Enabled LOCAL INFILE and imported the dataset using LOAD DATA LOCAL INFILE.

## Result

Successfully imported all 9800 rows into MySQL.

## Key Learning

Import Wizard is not always reliable for large datasets. Understanding alternative import methods is important for data analysis projects.
