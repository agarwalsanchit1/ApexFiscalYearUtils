public class FiscalYearUtils {
	public static Integer getCurrentFiscalYear() {
		return getFiscalYearForDate(System.today());
	}

	public static Integer getFiscalYearForDate(Date dt) {
		if(dt == null) {
			throw new DateException('Date is required');
		}

		Organization organization = [
			SELECT FiscalYearStartMonth, UsesStartDateAsFiscalYearName
			FROM Organization
			WHERE id=:Userinfo.getOrganizationId()
		];

		Integer currentFY;
		if (dt.month() >= organization.FiscalYearStartMonth) {
			if (organization.UsesStartDateAsFiscalYearName) {
				currentFY = dt.year();
			} else {
				currentFY = dt.year() + 1;
			}
		} else {
			if (organization.UsesStartDateAsFiscalYearName) {
				currentFY = dt.year() - 1;
			} else {
				currentFY = dt.year();
			}
		}
		return currentFY;
	}
	
	private class DateException extends Exception {}
}