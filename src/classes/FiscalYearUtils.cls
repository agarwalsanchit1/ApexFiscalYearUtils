public class FiscalYearUtils {

    public static Integer getCurrentFiscalYear() {
        return getFiscalYear(System.today());
    }

    public static Integer getFiscalYearForDate(Date dt) {
        if(dt == null) throw new DateException('Date is required');


        if(FISCAL_YEAR_SETTINGS.isEmpty()) System.today().year();
        else return Integer.valueOf(FISCAL_YEAR_SETTINGS[0].Name);
    }

    private static List<FiscalYearSettings> FISCAL_YEAR_SETTINGS {
        get {
            if(FISCAL_YEAR_SETTINGS == null) FISCAL_YEAR_SETTINGS = getFiscalYearSettings();
            return FISCAL_YEAR_SETTINGS;
        }
    }

    private class DateException extends Exception {}

}