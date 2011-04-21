import java.lang.annotation.*
import static java.lang.annotation.RetentionPolicy.*
import static java.lang.annotation.ElementType.*

enum DataExtensionType { GENE }

@Retention(RUNTIME)
@Target([TYPE])
@interface DataExtension {
	DataExtensionType type();
	String label();
}