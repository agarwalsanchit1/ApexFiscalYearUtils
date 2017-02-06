@isTest
private class FiscalYearUtils_Tests {

    @isTest
    static void getFiscalYearForDatetime() {
        String stage = [
            SELECT Id, MasterLabel
            FROM OpportunityStage
            WHERE IsActive = true
            LIMIT 1
        ].MasterLabel;

        Opportunity opportunity = new Opportunity(
            CloseDate = System.today(),
            Name      = 'Test opportunity',
            StageName = stage
        );
        insert opportunity;
        opportunity = [SELECT Id, CreatedDate FROM Opportunity];

        Test.startTest();

        AggregateResult soqlFY = [
            SELECT COUNT(Id) cnt, FISCAL_YEAR(CreatedDate) fy
            FROM Opportunity
            WHERE Id = :opportunity.Id
            GROUP BY FISCAL_YEAR(CreatedDate)
        ][0];

        System.assertEquals(soqlFY.get('fy'), FiscalYearUtils.getCurrentFiscalYear());
        System.assertEquals(soqlFY.get('fy'), FiscalYearUtils.getFiscalYear(opportunity.CreatedDate));

        Test.stopTest();
    }

    @isTest
    static void getFiscalYearForDate() {
        String stage = [
            SELECT Id, MasterLabel
            FROM OpportunityStage
            WHERE IsActive = true
            LIMIT 1
        ].MasterLabel;

        Opportunity opportunity = new Opportunity(
            CloseDate = System.today(),
            Name      = 'Test opportunity',
            StageName = stage
        );
        insert opportunity;

        Test.startTest();

        AggregateResult soqlFY = [
            SELECT COUNT(Id) cnt, FISCAL_YEAR(CloseDate) fy
            FROM Opportunity
            WHERE Id = :opportunity.Id
            GROUP BY FISCAL_YEAR(CloseDate)
        ][0];

        System.assertEquals(soqlFY.get('fy'), FiscalYearUtils.getCurrentFiscalYear());
        System.assertEquals(soqlFY.get('fy'), FiscalYearUtils.getFiscalYear(opportunity.CloseDate));

        Test.stopTest();
    }

    @isTest
    static void throwErrorForNullDatetimeFiscalYear() {
        try {
            Datetime dt = null;
            FiscalYearUtils.getFiscalYear(dt);
            throw new ExpectedException('Exception expected');
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains('Datetime is required'), ex.getMessage());
        }
    }

    @isTest
    static void throwErrorForNullDateFiscalYear() {
        try {
            Date d = null;
            FiscalYearUtils.getFiscalYear(d);
            throw new ExpectedException('Exception expected');
        } catch(Exception ex) {
            System.assert(ex.getMessage().contains('Date is required'), ex.getMessage());
        }
    }

    private class ExpectedException extends Exception {}

}