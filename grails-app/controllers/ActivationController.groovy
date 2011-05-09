import java.net.URLEncoder
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.authentication.BadCredentialsException

class ActivationController {
	def securityService
	def daoAuthenticationProvider
	
    def newAccount = {
    		log.debug "preparing to create a new account"
    		if(params.token) {
    			String token = new String(params.token.getBytes(), "UTF-8");
    			def validRequestor = securityService.validateToken(token)
    				if(!validRequestor){
    					log.debug "invalid token"
    					flash.error = message(code:"activation.requestExpired")
    					redirect(controller:'home',action:"index")
    				}else{
    					log.debug "user token authenticated"
    					[userId:validRequestor]
    				}		
    		  }
    		else{
    			redirect(controller:'policies',action:"deniedAccess")
    			return
    		}
    		
    	}
    	
    	
    	def reset = {
    		log.debug "preparing to reset an existing account"
    		if(params.token) {
    			String token = new String(params.token.getBytes(), "UTF-8");
    			def validRequestor = securityService.validateToken(token)
    				if(!validRequestor){
    					log.debug "invalid token"
    					flash.error =  message(code:"activation.requestExpired")
    					redirect(controller:'home',action:"index")
    				}else{
    					log.debug "user token authenticated"
    					[userId:validRequestor]
    				}		
    		  }
    		else{
    			redirect(controller:'policies',action:"deniedAccess")
    			return
    		}
    	}
    	
    	def resetPassword = {
    		ResetPasswordCommand cmd ->
    		log.debug "userId : " + cmd.userId
    		log.debug "password : " + cmd.password
    		if(cmd.hasErrors()) {
    			flash['cmd'] = cmd
    			log.debug cmd.errors
    			def baseUrl = CH.config.grails.serverURL
    			def token = cmd.userId + "||" + System.currentTimeMillis()
    			def resetUrl = baseUrl+"/${g.appName()}/activation/reset?token=" + URLEncoder.encode(EncryptionUtil.encrypt(token), "UTF-8")
    			redirect(url:resetUrl)
    			return
    		}
    		else{
    			flash['cmd'] = cmd
    			log.debug "resetting password"
    			if(securityService.changeUserPassword(cmd.userId,cmd.password)){
    				def u = GDOCUser.findByUsername(cmd.userId)
    				if(session.userId){
    					flash.message =  message(code:"activation.changedPassword")
    					log.debug "$cmd.userId successfully changed password."
    					redirect(controller:'workflows',action:"index")
    					return
    				}else{
    					flash.message =  message(code:"activation.changedPassword")
    					log.debug "$cmd.userId successfully changed password."
    					redirect(controller:'home',action:"index")
    					return
    				}
    				
    			}else{
    				log.debug "$cmd.userId password has NOT been reset"
    				flash.message =  message(code:"activation.notChangedPassword")
    				redirect(controller:'home',action:"index")
    			}
    		}
    	}
    	
    	
    	def activateAccount = {
    		ActivationCommand cmd ->
    		if(cmd.hasErrors()) {
    			flash['cmd'] = cmd
    			log.debug cmd.errors
    			def baseUrl = CH.config.grails.serverURL
    			def token = cmd.userId + "||" + System.currentTimeMillis()
    			def activateUrl = baseUrl+"/${g.appName()}/activation/newAccount?token=" + URLEncoder.encode(EncryptionUtil.encrypt(token), "UTF-8")
    			redirect(url:activateUrl)
    			return
    		}
    		else{
    			flash['cmd'] = cmd
    			def newUser
    			def existingUser = GDOCUser.findByUsername(cmd.userId)
    			if(existingUser){
    				log.debug "user already exists"
    				flash.error = message(code:"activation.userAlreadyExists",args:[appTitle()])
    				redirect(controller:'home',action:"index")
					return
    			}
    			log.debug "now add the user to system with public access"
    			try{
					newUser = securityService.createNewUser(cmd.userId,cmd.password,cmd.firstName,cmd.lastName,cmd.userId,cmd.organization, cmd.title,null)
	    			if(newUser){
						//add to PUBLIC collab group
	    				def managerPublic = securityService.findCollaborationManager("PUBLIC")
	    				securityService.addUserToCollaborationGroup(managerPublic.username, newUser.getUsername(), "PUBLIC")
						saveUserOptions(cmd)
						try{
							def auth = new UsernamePasswordAuthenticationToken(cmd.userId, cmd.password) 
							def authToken = daoAuthenticationProvider.authenticate(auth) 
					 		SCH.context.authentication = authToken
							redirect(controller:'workflows',params:[firstLogin:true])
							return
						}catch(BadCredentialsException bce){
							log.debug bce
							flash.error = message(code:"activation.userNotAddedBadCredentials")
							redirect(controller:'registration',action:'index')
							return
						}
						redirect(controller:'workflows',params:[firstLogin:true])
	    			}

    			}catch (SecurityException se){
    				log.debug "user not added " + se
    				flash.error = message(code:"activation.userNotAdded")
    				redirect(controller:'registration',action:"index")
					return
    			}
				catch (Exception se){
    				log.debug "user not added " + se
    				flash.error = message(code:"activation.userNotAdded")
    				redirect(controller:'registration',action:"index")
					return
    			}
    		}
    	}

		private def saveUserOptions(command) {
			def gdocUser = GDOCUser.findByUsername(command.userId)
			def options = [:]
			options[UserOptionType.REASON] = command.reason
			options.each { key, value ->
				UserOption option = new UserOption()
				option.type = key
				option.value = value
				option.user = gdocUser
				if(!option.save())
					log.error option.errors
			}
			
		}
		
}
