package brainflow;

import java.util.HashMap;
import java.util.Map;

/**
 * enum to store all possible Wavelet Types
 */
public enum WaveletTypes
{

    HAAR (0),
    DB1 (1),
    DB2 (2),
    DB3 (3),
    DB4 (4),
    DB5 (5),
    DB6 (6),
    DB7 (7),
    DB8 (8),
    DB9 (9),
    DB10 (10),
    DB11 (11),
    DB12 (12),
    DB13 (13),
    DB14 (14),
    DB15 (15),
    BIOR1_1 (16),
    BIOR1_3 (17),
    BIOR1_5 (18),
    BIOR2_2 (19),
    BIOR2_4 (20),
    BIOR2_6 (21),
    BIOR2_8 (22),
    BIOR3_1 (23),
    BIOR3_3 (24),
    BIOR3_5 (25),
    BIOR3_7 (26),
    BIOR3_9 (27),
    BIOR4_4 (28),
    BIOR5_5 (29),
    BIOR6_8 (30),
    COIF1 (31),
    COIF2 (32),
    COIF3 (33),
    COIF4 (34),
    COIF5 (35),
    SYM2 (36),
    SYM3 (37),
    SYM4 (38),
    SYM5 (39),
    SYM6 (40),
    SYM7 (41),
    SYM8 (42),
    SYM9 (43),
    SYM10 (44);

    private final int value;
    private static final Map<Integer, WaveletTypes> map = new HashMap<Integer, WaveletTypes> ();

    public int get_code ()
    {
        return value;
    }

    public static String string_from_code (final int code)
    {
        return from_code (code).name ();
    }

    public static WaveletTypes from_code (final int code)
    {
        final WaveletTypes element = map.get (code);
        return element;
    }

    WaveletTypes (final int code)
    {
        value = code;
    }

    static
    {
        for (final WaveletTypes type : WaveletTypes.values ())
        {
            map.put (type.get_code (), type);
        }
    }
}
