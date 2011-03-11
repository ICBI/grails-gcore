import java.lang.annotation.*
import static java.lang.annotation.RetentionPolicy.*
import static java.lang.annotation.ElementType.*

enum ExtensionType { SEARCH, ANALYSIS }

@Retention(RUNTIME)
@Target([TYPE])
@interface Extension {
	String menu();
	ExtensionType type();
}