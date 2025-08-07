/*
    active-sessions-security.sql
    Session information with security context.
*/

SELECT
    s.session_id,
    s.login_name,
    s.host_name,
    s.program_name,
    s.client_interface_name,
    s.status,
    s.login_time,
    s.last_request_start_time,
    s.last_request_end_time,
    s.reads,
    s.writes,
    s.logical_reads,
    s.cpu_time,
    s.memory_usage,
    s.original_login_name,
    s.nt_domain,
    s.nt_user_name,
    s.is_user_process,
    c.net_transport,
    c.protocol_type,
    c.encrypt_option,
    c.auth_scheme,
    c.client_net_address,
    c.client_tcp_port,
    c.local_net_address,
    c.local_tcp_port,
    c.connect_time,
    c.last_read,
    c.last_write
FROM sys.dm_exec_sessions AS s
LEFT JOIN sys.dm_exec_connections AS c
       ON s.session_id = c.session_id
ORDER BY s.session_id;
