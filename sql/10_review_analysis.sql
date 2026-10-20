-- ============================================================
-- SQL Business Analytics
-- Step 23: Customer Review Analysis
-- ============================================================

SELECT
    review_score,
    COUNT(*) AS review_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage,

    ROUND(
        AVG(
            COALESCE(
                LENGTH(review_comment_message),
                0
            )
        ),
        2
    ) AS average_comment_length

FROM order_reviews

GROUP BY review_score

ORDER BY review_score;