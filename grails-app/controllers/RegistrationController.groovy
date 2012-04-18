import grails.converters.*
import com.megatome.grails.RecaptchaService
import java.net.URLEncoder
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder as SCH
import org.springframework.security.authentication.BadCredentialsException

class RegistrationController {

	def securityService
	def mailService
	def ldapAuthProvider
	RecaptchaService recaptchaService
	
    def index = {
		def categoryList = [message(code: "registration.publicUser"), message(code: "registration.georgetownUser")]
		def departmentList = [message(code: "registration.oncology"), 
							  message(code: "registration.pathology"),
							  message(code: "registraion.radiation"),
							  message(code: "registration.biostatistics"),
							  message(code: "registration.bioinformatics"),
							  message(code: "registration.biomathmatics"),
							  message(code: "registration.student")]
		[departmentList:departmentList,categoryList:categoryList]
	}
	
	def publicRegistration = {
		
	}
	
	def passwordReset = {
		log.debug "preparing to send account change request"
		if(session.userId){
			log.debug "$session.userId is logged in, requesting password change"
			def netId = securityService.isNetId(session.userId.trim())
			if(netId){
				[netId:true]
			}
		}
		else{
			log.debug "user is not logged in, requesting password change"
		}
		
	}
	
	def resetLoginCredentials = {
		RegistrationPublicCommand cmd ->
			log.debug "userId : " + cmd.userId
			log.debug "captcha - " + params
			if(cmd.hasErrors()) {
				flash['cmd'] = cmd
				log.debug cmd.errors
				redirect(action:'passwordReset')
				return
			}else{
				def recaptchaOK = true
				if (!recaptchaService.verifyAnswer(session, request.getRemoteAddr(), params)) {
				    recaptchaOK = false
					flash.error = message(code: "registration.incorrect")
					log.debug "incorrect code verification"
					redirect(action:'passwordReset')
					return
				}
				recaptchaService.cleanUp(session)
				def existingUser = GDOCUser.findByUsername(cmd.userId)
				if(!existingUser){
					log.debug cmd.userId + " user was not found in the G-DOC system."
					flash.error = message(code: "registration.userNotFound", args: [cmd.userId])
					redirect(action:'passwordReset')
					return
				}else{
					log.debug cmd.userId + " passed reset validation"
					def baseUrl = CH.config.grails.serverURL
					def token = cmd.userId + "||" + System.currentTimeMillis()
					def resetUrl = baseUrl+"/activation/reset?token=" + URLEncoder.encode(EncryptionUtil.encrypt(token), "UTF-8")
					if(existingUser.email){
						mailService.sendMail {
						   to "$existingUser.email"
						   from "gdoc-help@georgetown.edu"
						   subject message(code: "registration.subject", args: [g.appTitle(noHtml:true)])
						   body  message(code: "registration.body", args: [cmd.userId, g.appTitle(noHtml:true), resetUrl])
						}
						flash.message = message(code: "registration.thanks", args: [cmd.userId])
						redirect(action:'confirmation')
						return
					}else{
						flash.message = message(code: "registration.noEmail", args: [cmd.userId])
						redirect(action:'confirmation')
						return
					}
					
				}
			}
	}
	
	def registerPublic = {
		RegistrationPublicCommand cmd ->
			if(cmd.hasErrors()) {
				flash['cmd'] = cmd
				log.debug cmd.errors
				redirect(action:'index')
				return
			}else{
				flash['cmd'] = cmd
				def recaptchaOK = true
				if (!recaptchaService.verifyAnswer(session, request.getRemoteAddr(), params)) {
				    recaptchaOK = false
					flash.error = message(code: "registration.incorrect")
					log.debug "incorrect code verification"
					redirect(action:'index')
					return
				}
				recaptchaService.cleanUp(session)
				def existingUser = GDOCUser.findByUsername(cmd.userId)
				if(existingUser){
					log.debug cmd.userId + " already exists as a user in the G-DOC system."
					flash.error = message(code: "registration.exists", args: [cmd.userId, g.appTitle()])
					redirect(action:'index')
					return
				}else{
					log.debug cmd.userId + " passed registration validation"
					def baseUrl = CH.config.grails.serverURL
					def token = cmd.userId + "||" + System.currentTimeMillis()
					def activateUrl = baseUrl+"/activation/newAccount?token=" + URLEncoder.encode(EncryptionUtil.encrypt(token), "UTF-8")
					log.debug activateUrl
					mailService.sendMail {
					   to "$cmd.userId"
					   from "gdoc-help@georgetown.edu"
					   subject message(code: "registration.activate", args: [g.appTitle(noHtml:true)])
					   body message(code: "registration.activationBody", args: [cmd.userId, g.appTitle(noHtml:true), activateUrl])
					}
					flash.message = message(code: "registration.activationThanks", args: [cmd.userId])
					redirect(action:'confirmation')
					return
				}
			}
	}
	
	def confirmation = {
		
	}
	
	
	def register = { RegistrationCommand cmd ->
		log.debug "netId : " + cmd.netId
		log.debug "department:" + cmd.department 
		log.debug cmd.errors
		if(cmd.hasErrors()) {
			flash['cmd'] = cmd
			//log.debug cmd.errors
			redirect(action:'index')
		} else {
			log.debug "no errors, begin registration"
			flash['cmd'] = cmd
			//check if user already exists
			def existingUser = GDOCUser.findByUsername(cmd.netId)
			if(existingUser){
				log.debug cmd.netId + " already exists as a user in the system. Use Net-Id credentials to login above"
				flash.error = message(code: "registration.netIdExists", args: [cmd.netId])
				redirect(action:'index')
				return
			}else{
				//if user doesn't exist, validate the netID
				def newUser = securityService.validateNetId(cmd.netId.trim(), cmd.department)
				if(newUser){
					//check to make sure user has required fields
					if(newUser.username && newUser.firstName && newUser.lastName){
						//if user's netId is valid, add user to G-DOC system
							//add to PUBLIC collab group
							def managerPublic = securityService.findCollaborationManager("PUBLIC")
							securityService.addUserToCollaborationGroup(managerPublic.username, newUser.username, "PUBLIC")
							session.profileLoaded = false
							session.userId = cmd.netId
							try{
								def auth = new UsernamePasswordAuthenticationToken(cmd.netId, cmd.password) 
								def authToken = ldapAuthProvider.authenticate(auth) 
						 		SCH.context.authentication = authToken
								redirect(controller:'workflows',params:[firstLogin:true])
								return
							}catch(BadCredentialsException bce){
								log.debug bce
								flash.error = message(code: "registration.netIdError", args: [g.appTitle()])
								redirect(action:'index')
								return
							}
							
					}else{
						log.debug "user has NET ID, but missing a required field (username, firstName or lastName)"
						flash.error = message(code: "registration.netIdName", args: [g.appTitle()])
						redirect(action:'index')
						return
					}
				}else{
					log.debug cmd.netId + " is an invalid Net-Id."
					flash.error = message(code: "registration.invalidNetId", args: [cmd.netId])
					redirect(action:'index')
					return
				}
			}
			
			redirect(action:'index')
		}

	}
	
}
