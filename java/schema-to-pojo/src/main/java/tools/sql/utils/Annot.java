package tools.sql.utils;

public enum Annot {
    PK("javax.persistence", "Id"),
    AUTO_INC("javax.persistence", "GeneratedValue");

    private final String pack;
    private final String name;

    Annot(String pack, String name) {
        this.pack = pack;
        this.name = name;
    }

    public String getPack() {
        return pack;
    }

    public String getName() {
        return name;
    }
}
