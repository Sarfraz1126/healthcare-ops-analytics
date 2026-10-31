# Healthcare Operations Analytics

Analysis of hospital visits, costs, readmissions and imaging use,
built with PostgreSQL, Python and Power BI on synthetic patient data.

## Questions this project answers

1. Which medical conditions cost the most?
2. How many patients come back to hospital within 30 days?
3. How long do hospital stays last, and what makes them longer?
4. How are CT, MRI and X-ray being used?

## The data

Synthetic (computer-generated) records for 1,000 patients from
[Synthea](https://synthetichealth.github.io/synthea/). No real patients.
Personal details like names, addresses and ID numbers were left out on
purpose, the same way you would handle real data under GDPR.

## How the tables connect

Think of it like a hospital's paperwork:

- **patients**: the patient register. One line per patient.
- **encounters**: the visit log. One line per visit. Every other table points here.
- **conditions**: the diagnosis list. One line per diagnosis made during a visit.
- **imaging_studies**: the radiology log. One line per scan taken during a visit.

Each visit belongs to a patient. Each diagnosis and each scan belongs to a visit.

    patient → visit → diagnoses
                    → scans

## What each table holds

### patients

Who the patient is: age, gender, county, and date of death if they died.

### encounters

When the visit started and ended, what type it was (inpatient,
emergency, outpatient), why the patient came in, and what it cost.

### conditions

What the patient was diagnosed with, and when it started and ended.
A visit can have several diagnoses, so costs are counted once per
visit, never once per diagnosis, to avoid double-counting.

### imaging_studies

What kind of scan was done (e.g. X-ray, CT, MRI), which body part,
and on which date.

## Tools

PostgreSQL (data storage and queries) · Python/pandas (cleaning) · Power BI (dashboard)

## Status

🚧 In progress
