public class FiscalYearUtils {
    public static Integer getCurrentFiscalYear() {
        return getFiscalYear(System.today());
    }

    public static Integer getFiscalYear(Date dt) {
        if(dt == null) {
            throw new DateException('Date is required');
        }

        Integer currentFY;
        List<FiscalYearSettings> fiscalYearSettings = [
            SELECT Id, Name, StartDate, EndDate, IsStandardYear, PeriodId, YearType
            FROM FiscalYearSettings
            WHERE StartDate <= TODAY
            AND EndDate >= TODAY
        ];

        if(fiscalYearSettings.isEmpty()) {
            currentFY = System.today().year();
        } else {
            currentFY = Integer.valueOf(fiscalYearSettings[0].Name);
        }

        return currentFY;
    }

    private class DateException extends Exception {}
}