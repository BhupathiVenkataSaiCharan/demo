/**
* @File Name : RegisterAndLoginController.cls
* @Description : Create User or Validate New User
* @Author :	Charan
* @Last Modified By : December 24, 2024
* @Last Modified On : December 24, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 24, 2024 |   | Initial Version
**/

public class RegisterAndLoginController {
	@AuraEnabled
	public static void createNewUser(String fName, String lName, String uEmail, String uPassword){

		String uName = fName + ' ' + lName;
		try{
			SiteUser__c u = new SiteUser__c(
				Name = uName,
				Email__c = uEmail,
				Password__c = uPassword
			);
			insert u;
		}
		catch(Exception e){
			System.debug('Exception==>' + e.getMessage());
			if(e.getMessage().contains('DUPLICATE')){
				throw new AuraHandledException('User Already Exists. Please try logging in');
			}else if(e.getMessage().contains('REQUIRED')){
				throw new AuraHandledException('Required fields are missing');
			}
			throw new AuraHandledException(e.getMessage());
		}	
	}

	@AuraEnabled
	public static Boolean checkUser(String uEmail, String uPassword){

		try{
			List<SiteUser__c> existingUser = [SELECT Id,Name,Email__c,Password__c FROM SiteUser__c WHERE Email__c = :uEmail LIMIT 1];
			if(!existingUser.isEmpty() && existingUser[0].Password__c == uPassword){
				return true;
			}
			return false;
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}
}