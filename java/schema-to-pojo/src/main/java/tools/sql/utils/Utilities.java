package tools.sql.utils;

import org.apache.commons.io.FileUtils;
import tools.sql.entity.JTable;

import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class Utilities {

    public static String getType(String sqlType) {
        if (sqlType.startsWith("varchar")) {
            return "String";
        } else if (sqlType.contains("int")) {
            return "Long";
        } else if (sqlType.startsWith("date") || sqlType.startsWith("time")) {
            return "LocalDateTime";
        }
        return "";
    }

    public static String formalizeName(String name) {
        return Utilities.uncapitalize(Stream.of(name.split("_")).map(n -> capitalize(n)).collect(Collectors.joining()));
    }

    public static String uncapitalize(final String line) {
        return Character.toLowerCase(line.charAt(0)) + line.substring(1);
    }

    public static String capitalize(final String line) {
        return Character.toUpperCase(line.charAt(0)) + line.substring(1);
    }

    public static void createClass(JTable jTable) throws IOException {
        File file = new File("." + jTable.getRelativePath());
        FileUtils.write(file, jTable.toJava(), Charset.defaultCharset());
    }

}
