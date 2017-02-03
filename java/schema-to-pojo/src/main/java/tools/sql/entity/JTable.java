package tools.sql.entity;

import tools.sql.utils.Utilities;

import java.util.Collection;

public class JTable {
    private final String packageName;
    private final String name;
    private Collection<JColumn> columns;

    public JTable(String packageName, String name, Collection<JColumn> columns) {
        this.packageName = packageName;
        this.name = name;
        this.columns = columns;
    }

    public String getName() {
        return name;
    }

    public Collection<JColumn> getColumns() {
        return columns;
    }

    public String toJava() {
        StringBuilder sb = new StringBuilder();
        sb.append("package ");
        sb.append(getPackageName());
        sb.append(";\n");
        for (JColumn column : columns) {
            sb.append(column.toJavaImports());
        }
        sb.append("public class " + Utilities.capitalize(name) + " {\n");
        for (JColumn column : columns) {
            sb.append(column.toJava());
        }
        for (JColumn column : columns) {
            sb.append(column.toJavaGetterSetter());
        }
        sb.append("}");
        return sb.toString();
    }

    public String getPackageName() {
        return packageName;
    }

    public String getRelativePath() {
        return "/" + getPackageName().replaceAll("\\.", "/") + "." + Utilities.capitalize(getName()) + ".java";
    }
}
