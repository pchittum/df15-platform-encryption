public with sharing class TenantSecretService {
	public TenantSecretService() {
		
	}

	@AuraEnabled
	public static TenantSecret rotateKey(){
		String descText = UserInfo.getName() + ' new secret via Lightning';

        TenantSecret newSecret = new TenantSecret(Description=descText);

        try {
            insert newSecret;
        } catch (Exception e){
        	//will handle this on client side
            System.debug(e);
        }

        return newSecret;
    }

    public static TenantSecret initActiveTenantSecret(){

    	return fetchLastNTenantSecrets(1,'ACTIVE')[0];

    }

    @AuraEnabled
    public static List<TenantSecret> fetchLastNTenantSecrets(Integer limitNum, String status){
    	List<TenantSecret> secrets = new List<TenantSecret>();

    	String limitStr = ' LIMIT ' + limitNum;
    	String baseQuery = 'SELECT Id, CreatedDate, Description, Version, Status FROM TenantSecret WHERE Status =: status ORDER BY CreatedDate DESC{0}';

    	String queryStr = status == null ? baseQuery : String.format(baseQuery, new List<String>{limitStr});

    	secrets = Database.query(queryStr);

    	return secrets;
    }

}