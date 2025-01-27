/**
* @File Name : RegisterAndLoginController.cls
* @Description : Create User or Validate New User
* @Author :	Charan
* @Last Modified By : Charan
* @Last Modified On : December 24, 2024
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 24, 2024 |   | Initial Version
**/

public class RegisterAndLoginController {
	@AuraEnabled
	public static String createNewUser(String fName, String lName, String uEmail, String uPassword){

		String uName = fName + ' ' + lName;
		try{
			SiteUser__c u = new SiteUser__c(
				Name = uName,
				Email__c = uEmail,
				Password__c = uPassword
			);
			insert u;
			return Label.User_Creation;
		}
		catch(Exception e){
			System.debug('Exception==>' + e.getMessage());
			if(e.getMessage().contains('DUPLICATE')){
				throw new AuraHandledException(Label.Duplicate_User_Error);
			}else if(e.getMessage().contains('REQUIRED')){
				throw new AuraHandledException('Required fields are missing');
			}
			throw new AuraHandledException(e.getMessage());
		}	
	}

	@AuraEnabled
	public static String checkUser(String uEmail, String uPassword){
		try{
			List<SiteUser__c> existingUser = [SELECT Id,Name,Email__c,Password__c FROM SiteUser__c WHERE Email__c = :uEmail LIMIT 1];
			
			if(existingUser.isEmpty()){
				return 'No User';
			}
			else if(existingUser[0].Password__c != uPassword){
				return 'Wrong Password';
			}else{
				return '';
			}
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}
	}
}