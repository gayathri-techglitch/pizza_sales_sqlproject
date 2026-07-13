QUERY - 1
-- Retrieve the total number of orders placed
select count(order_id) as total_orders from orders;

QUERY - 2
-- Calculate total revenue generated from pizza sales
SELECT 
    ROUND(SUM(o.quantity * p.price), 2) AS total_sales
FROM
    order_details o
        JOIN
    pizzas p ON o.pizza_id = p.pizza_id;

QUERY - 3
-- identify the highest priced pizza
SELECT 
    pt.name, p.price
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
ORDER BY p.price DESC
LIMIT 1;

QUERY - 4
-- identify the most common pizza size ordered
SELECT 
    p.size, COUNT(o.order_details_id) AS order_count
FROM
    pizzas p
        JOIN
    order_details o ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY order_count DESC;

QUERY - 5
-- List the tpo 5 most ordered pizza types along with their quantities
SELECT 
    pt.name, SUM(od.quantity) AS quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY quantity DESC
LIMIT 5


QUERY - 6
-- Join the tables to find the total quantity of each pizza ordered
SELECT 
    pt.category, SUM(o.quantity) AS quantity
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details o ON p.pizza_id = o.pizza_id
GROUP BY pt.category
ORDER BY quantity DESC;

QUERY - 7
-- Determine the distribution of orders by hour of the day
SELECT 
    HOUR(order_time), COUNT(order_id)
FROM
    orders
GROUP BY HOUR(order_time);

QUERY - 8
-- Find the category wise distribution of pizzas
SELECT 
    category, COUNT(name)
FROM
    pizza_types
GROUP BY category;

QUERY - 9
-- Group the orders by date and calculate average no of pizzas ordered per day
SELECT 
    ROUND(AVG(quantity), 0) as avg_pizzas_per_day
FROM
    (SELECT 
        o.order_date, SUM(od.quantity) AS quantity
    FROM
        orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.order_date) AS order_qunatity;

QUERY - 10
-- Determine the top 3 most ordered pizzas based on the revenue
SELECT 
    pt.name, SUM(od.quantity * p.price) AS revenue
FROM
    pizza_types pt
        JOIN
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
        JOIN
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.name
ORDER BY revenue DESC
LIMIT 3;

QUERY - 11
-- Calculate percentage contribution of each pizza type to revenue
SELECT 
    pt.category,
    ROUND(SUM(od1.quantity * p1.price) / (SELECT 
                    SUM(od.quantity * p.price)
                FROM
                    order_details od
                        JOIN
                    pizzas p ON od.pizza_id = p.pizza_id) * 100,
            2) AS revenue_percentage
FROM
    pizza_types pt
        JOIN
    pizzas p1 ON pt.pizza_type_id = p1.pizza_type_id
        JOIN
    order_details od1 ON od1.pizza_id = p1.pizza_id
GROUP BY pt.category
ORDER BY revenue_percentage DESC;

QUERY - 12
-- Analyze the cumulative revenue generated per time
select order_date,sum(revenue) over(order by order_date) from
(select o.order_date ,sum(od.quantity*p.price) as revenue
from orders o join order_details od
on o.order_id = od.order_id
join pizzas p 
on od.pizza_id = p.pizza_id
group by o.order_date ) as sales

QUERY - 13
-- Determine the top 3 most ordered pizza types
-- based on revenue for each pizza category
select name,revenue from
(select name,category,revenue,
rank() over(partition by category order by revenue desc) as rnk
from 
(select pt.category,pt.name,sum(od.quantity*p.price) as revenue from order_details od join pizzas p
on od.pizza_id = p.pizza_id
join pizza_types pt 
on pt.pizza_type_id = p.pizza_type_id
group by pt.name,pt.category) as a) as b
where rnk <=3;

