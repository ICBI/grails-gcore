import java.lang.annotation.*
import static java.lang.annotation.RetentionPolicy.*
import static java.lang.annotation.ElementType.*

enum WorkflowExtensionType { REPORTER }

@Retention(RUNTIME)
@Target([FIELD])
@interface WorkflowExtension {
	String label();
	WorkflowExtensionType type();
}