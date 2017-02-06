public class FiscalYearUtils {

    public static Integer getCurrentFiscalYear() {
        return getFiscalYear(System.today());
    }

    public static Integer getFiscalYear(Datetime dt) {
        if(dt == null) throw new DateException('Datetime is required');

        return getFiscalYear(dt.date());
    }

    public static Integer getFiscalYear(Date d) {
        if(d == null) throw new DateException('Date is required');

        Integer fiscalYear;

        if(FISCAL_YEAR_SETTINGS.isEmpty()) fiscalYear = calculateStandardFiscalYear(d);
        else fiscalYear = calculateCustomFiscalYear(d);

        return fiscalYear;
    }

    private static List<FiscalYearSettings> FISCAL_YEAR_SETTINGS {
        get {
            if(FISCAL_YEAR_SETTINGS == null) {
                FISCAL_YEAR_SETTINGS =  [
                    SELECT Id, Name, StartDate, EndDate, IsStandardYear, PeriodId, YearType
                    FROM FiscalYearSettings
                ];
            }
            return FISCAL_YEAR_SETTINGS;
        }
    }

    private static Organization ORGANIZATION {
        get {
            if(ORGANIZATION == null) {
                ORGANIZATION = [SELECT Id, FiscalYearStartMonth FROM Organization];
            }
            return ORGANIZATION;
        }
    }

    private static Integer calculateStandardFiscalYear(Date d) {
        if(d.month() >= ORGANIZATION.FiscalYearStartMonth) return d.year() + 1;
        else return d.year();
    }

    private static Integer calculateCustomFiscalYear(Date d) {
        Integer fiscalYear;
        for(FiscalYearSettings settings : FISCAL_YEAR_SETTINGS) {
            if(settings.StartDate >= d && settings.EndDate <= d) {
                fiscalYear = Integer.valueOf(settings.Name);
                break;
            }
        }

        if(fiscalYear == null) throw new DateException('Custom fiscal settings not found for date ' + d.format());

        return fiscalYear;
    }

    private class DateException extends Exception {}

}