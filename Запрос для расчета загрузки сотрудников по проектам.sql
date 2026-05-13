SELECT
    e.employee_id,
    e.full_name AS employee_name,
    e.department,
    e.position,
    p.project_id,
    p.project_name,
    -- Суммируем фактические часы по задачам сотрудника в проекте
    ISNULL(SUM(t.actual_hours), 0) AS total_project_hours,
    -- Рабочая неделя = 40 часов
    40 AS weekly_work_hours,
    -- Вычисляем процент загрузки
    ROUND(
        (ISNULL(SUM(t.actual_hours), 0) * 100.0 / 40.0), 
        2
    ) AS workload_percentage
FROM
    employees e
    -- LEFT JOIN чтобы включить всех сотрудников, даже без задач
    LEFT JOIN tasks t ON e.employee_id = t.assignee_id
    LEFT JOIN projects p ON t.project_id = p.project_id
GROUP BY
    e.employee_id,
    e.full_name,
    e.department,
    e.position,
    p.project_id,
    p.project_name
ORDER BY
    e.employee_id,
    workload_percentage DESC;
GO