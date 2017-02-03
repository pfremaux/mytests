package tools.sql;

import tools.sql.entity.JColumn;
import tools.sql.entity.JTable;
import tools.sql.utils.Annot;
import tools.sql.utils.Utilities;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

public class Main {
    public static void main(String... a) throws IOException {
        String basePackage = "fr.pfr.toto";
        String pathname = "src/main/java/test.sql";
        File file = new File(pathname);
        System.out.println(file.getAbsolutePath()+ file.exists());
        String sql = new String(Files.readAllBytes(Paths.get(pathname)));
        //System.out.println(sql);
        sql = normalizeScript(sql);
        //System.out.println(sql);
        String[] creations = sql.split("create table");
        for (String creation : creations) {
            String trim1 = creation.trim();
            int i = trim1.indexOf(" ");
            if (i == -1)
                continue;
            String tableName = trim1.substring(0, i);
            System.out.println(tableName);
            String rest = trim1.substring(i);
            String[] sqlInstructions = rest.replaceAll("[\\(\\);]", " ").split(",");// TODO gaffe au cas varchar ()
            Map<String, JColumn> jcols = new HashMap<>();
            for (String sqlInstruction : sqlInstructions) {
                String trim = sqlInstruction.trim();
                if (trim.startsWith("primary key")) {
                    String name = trim.substring("primary key ".length());
                    JColumn jcol = jcols.get(name);
                    jcol.addAnnot(Annot.PK);
                    jcol.addAnnot(Annot.AUTO_INC);
                    continue;
                }
                int j = trim.indexOf(" ");
                String columnName = trim.substring(0, j);
                String instructionsAfterColumnName = trim.substring(j).trim();
                String javaType = getColumnTypeCorrespondingToJava(instructionsAfterColumnName);
                if (javaType == "") {
                    System.out.println("skipping line : " + sqlInstruction);
                    continue;
                }
                JColumn c = new JColumn(Utilities.formalizeName(columnName), javaType);
                jcols.put(c.getName(), c);
            }
            JTable t = new JTable(basePackage, Utilities.formalizeName(tableName), jcols.values());
            System.out.println(t.toJava());
            Utilities.createClass(t);
        }
    }

    private static String getColumnTypeCorrespondingToJava(String instructionsAfterColumnName) {
        int nextBlank = instructionsAfterColumnName.indexOf(" ");
        String type;
        if (nextBlank != -1)
            type = instructionsAfterColumnName.substring(0, nextBlank);
        else
            type = instructionsAfterColumnName;
        return Utilities.getType(type);
    }

    private static String normalizeScript(String sql) {
        return sql.replaceAll("\\s\\s", " ").replaceAll("`", "").toLowerCase().trim();
    }
}
