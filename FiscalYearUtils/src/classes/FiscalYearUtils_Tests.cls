@isTest
private class FiscalYearUtils_Tests {	
	@isTest
	static void getFiscalYear() {
		String stage = [
			SELECT Id, MasterLabel
			FROM OpportunityStage
			WHERE IsActive = true
			LIMIT 1
		].MasterLabel;
		
		Opportunity opportunity = new Opportunity(
			CloseDate = System.today()
			,StageName = stage
		);
		insert opportunity;

		AggregateResult soqlFY = [
			SELECT COUNT(Id) cnt, FISCAL_YEAR(CloseDate) fy
			FROM Opportunity
			WHERE Id = :opportunity.Id
			GROUP BY FISCAL_YEAR(CloseDate)
		][0];

		System.assertEquals(soqlFY.get('fy'), DateUtils.getCurrentFiscalYear());
		System.assertEquals(soqlFY.get('fy'), DateUtils.getFiscalYearForDate(opportunity.CloseDate));
	}

    @isTest
	static void throwErrorForNullDateFiscalYear() {
		try {
			DateUtils.getFiscalYearForDate(null);
			throw new ExpectedException('Exception expected');
		} catch(Exception ex) {
			System.assert(ex.getMessage().contains('Date is required'));
		}
	}
	
	private class ExpectedException extends Exception {}
}