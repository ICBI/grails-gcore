import java.lang.annotation.*
import static java.lang.annotation.RetentionPolicy.*
import static java.lang.annotation.ElementType.*

enum ExtensionType { SEARCH, ANALYSIS, CYTOSCAPE, NONE }

@Retention(RUNTIME)
@Target([TYPE])
@interface Extension {
	String menu();
	ExtensionType type();
	boolean hasListMetadata() default false;
}