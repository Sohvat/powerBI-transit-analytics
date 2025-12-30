# Power BI DAX Measures

## KPI Measures

### Total Activity
```dax
Total Activity :=
SUM ( events_cleaned_normalized[NormWeight] )
```

### Long Headways
```dax
Long Headways :=
CALCULATE (
    COUNTROWS ( headway_metrics ),
    headway_metrics[HeadwayMin] > 20
)
```
