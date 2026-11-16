imaging_studies stores one row per image, not per study (chest CT ≈ 335 rows/study). Always count scans with COUNT(DISTINCT id).
Inpatient descriptions are generic (“Encounter for problem”); planned vs unplanned admissions can’t be distinguished. Q2 reports all-cause 30-day readmissions. Some patients show regular ~monthly stays (likely scheduled treatment) that inflate the rate.
