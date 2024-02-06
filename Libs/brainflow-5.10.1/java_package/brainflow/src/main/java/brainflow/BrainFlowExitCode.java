package brainflow;

import java.util.HashMap;
import java.util.Map;

public enum BrainFlowExitCode
{

    STATUS_OK (0),
    PORT_ALREADY_OPEN_ERROR (1),
    UNABLE_TO_OPEN_PORT_ERROR (2),
    SET_PORT_ERROR (3),
    BOARD_WRITE_ERROR (4),
    INCOMMING_MSG_ERROR (5),
    INITIAL_MSG_ERROR (6),
    BOARD_NOT_READY_ERROR (7),
    STREAM_ALREADY_RUN_ERROR (8),
    INVALID_BUFFER_SIZE_ERROR (9),
    STREAM_THREAD_ERROR (10),
    STREAM_THREAD_IS_NOT_RUNNING (11),
    EMPTY_BUFFER_ERROR (12),
    INVALID_ARGUMENTS_ERROR (13),
    UNSUPPORTED_BOARD_ERROR (14),
    BOARD_NOT_CREATED_ERROR (15),
    ANOTHER_BOARD_IS_CREATED_ERROR (16),
    GENERAL_ERROR (17),
    SYNC_TIMEOUT_ERROR (18),
    JSON_NOT_FOUND_ERROR (19),
    NO_SUCH_DATA_IN_JSON_ERROR (20),
    CLASSIFIER_IS_NOT_PREPARED_ERROR (21),
    ANOTHER_CLASSIFIER_IS_PREPARED_ERROR (22),
    UNSUPPORTED_CLASSIFIER_AND_METRIC_COMBINATION_ERROR (23);

    private final int exit_code;
    private static final Map<Integer, BrainFlowExitCode> ec_map = new HashMap<Integer, BrainFlowExitCode> ();

    public int get_code ()
    {
        return exit_code;
    }

    public static String string_from_code (final int code)
    {
        return from_code (code).name ();
    }

    public static BrainFlowExitCode from_code (final int code)
    {
        final BrainFlowExitCode element = ec_map.get (code);
        return element;
    }

    BrainFlowExitCode (final int code)
    {
        exit_code = code;
    }

    static
    {
        for (final BrainFlowExitCode ec : BrainFlowExitCode.values ())
        {
            ec_map.put (ec.get_code (), ec);
        }
    }

}
