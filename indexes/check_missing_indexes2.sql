/*
Name: MissingIndexRecommendations

Purpose:
List recommended (missing) indexes from DMVs for the current database,
ranked by an IndexAdvantage score to help you prioritize what to create.

*/

SELECT
     indexDetails.[object_id]                                              AS ObjectId
    ,indexDetails.[statement]                                              AS FullyQualifiedObjectName
    ,indexDetails.[equality_columns]                                       AS EqualityColumns
    ,indexDetails.[inequality_columns]                                     AS InequalityColumns
    ,indexDetails.[included_columns]                                       AS IncludedColumns
    ,groupStats.[unique_compiles]                                          AS UniqueCompiles
    ,groupStats.[user_seeks]                                               AS UserSeeks
    ,groupStats.[user_scans]                                               AS UserScans
    ,groupStats.[last_user_seek]                                           AS LastUserSeekTime
    ,groupStats.[last_user_scan]                                           AS LastUserScanTime
    ,groupStats.[avg_total_user_cost]                                      AS AvgTotalUserCost
    ,groupStats.[avg_user_impact]                                          AS AvgUserImpact
    ,groupStats.[system_seeks]                                             AS SystemSeeks
    ,groupStats.[system_scans]                                             AS SystemScans
    ,groupStats.[last_system_seek]                                         AS LastSystemSeekTime
    ,groupStats.[last_system_scan]                                         AS LastSystemScanTime
    ,groupStats.[avg_total_system_cost]                                    AS AvgTotalSystemCost
    ,groupStats.[avg_system_impact]                                        AS AvgSystemImpact
    ,groupStats.[user_seeks] * groupStats.[avg_total_user_cost]
       * (groupStats.[avg_user_impact] * 0.01)                             AS IndexAdvantage
    ,'CREATE INDEX [Missing_IXNC_' + OBJECT_NAME(indexDetails.[object_id]) + '_'
       + REPLACE(REPLACE(REPLACE(ISNULL(indexDetails.[equality_columns], ''), ', ', '_'), '[', ''), ']', '')
       + CASE
           WHEN indexDetails.[equality_columns] IS NOT NULL
             AND indexDetails.[inequality_columns] IS NOT NULL
           THEN '_'
           ELSE ''
         END
       + REPLACE(REPLACE(REPLACE(ISNULL(indexDetails.[inequality_columns], ''), ', ', '_'), '[', ''), ']', '')
       + '_' + LEFT(CAST(NEWID() AS nvarchar(64)), 5) + '] ON '
       + indexDetails.[statement] + ' ('
       + ISNULL(indexDetails.[equality_columns], '')
       + CASE
           WHEN indexDetails.[equality_columns] IS NOT NULL
             AND indexDetails.[inequality_columns] IS NOT NULL
           THEN ','
           ELSE ''
         END
       + ISNULL(indexDetails.[inequality_columns], '') + ')'
       + ISNULL(' INCLUDE (' + indexDetails.[included_columns] + ')', '')   AS ProposedIndex
    ,CAST(CURRENT_TIMESTAMP AS smalldatetime)                               AS CollectionDate
FROM sys.dm_db_missing_index_group_stats AS groupStats WITH (NOLOCK)
INNER JOIN sys.dm_db_missing_index_groups AS indexGroups  WITH (NOLOCK)
        ON groupStats.group_handle = indexGroups.index_group_handle
INNER JOIN sys.dm_db_missing_index_details AS indexDetails WITH (NOLOCK)
        ON indexGroups.index_handle = indexDetails.index_handle
ORDER BY IndexAdvantage DESC
OPTION (RECOMPILE);
