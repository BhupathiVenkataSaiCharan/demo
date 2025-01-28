public class StaticKeywordController {
    
    public static String createAccount(){

        Account acc = new Account(
            Name = 'Test'
        );

        try{
            insert acc;
            return 'Account created';
        }catch(Exception e){
            return 'Error creating account';
        }
    }

    public String createNoAccount(){

        Account acc = new Account(
            Name = 'Test'
        );

        try{
            insert acc;
            return 'Account created';
        }catch(Exception e){
            return 'Error creating account';
        }
    }
}