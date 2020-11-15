use publications;
-- Challenge 1 - Most Profiting Authors

SELECT * FROM publications.titles;
SELECT * FROM publications.titleauthor;
SELECT * FROM publications.sales;

-- STEP 1 

SELECT titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100 / 100, 2) AS advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100, 2)
AS sales_loyalty 
FROM titleauthor
INNER JOIN sales
ON sales.title_id = titleauthor.title_id
INNER JOIN titles 
ON titles.title_id = titleauthor.title_id;


-- STEP2 
SELECT title_id, au_id, sum(sales_loyalty) as sum_loyalty, advance
FROM
	(SELECT titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100 / 100, 2) AS advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100, 2)
	AS sales_loyalty 
	FROM titleauthor
	INNER JOIN sales
	ON sales.title_id = titleauthor.title_id
	INNER JOIN titles 
	ON titles.title_id = titleauthor.title_id) as author_loyalty
GROUP BY au_id, title_id, advance;



-- STEP3 


SELECT au_id, (advance + sum_loyalty) as profits
FROM
	(SELECT title_id, au_id, sum(sales_loyalty) as sum_loyalty, advance
	FROM
		(SELECT titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100 / 100, 2) AS advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100, 2)
		AS sales_loyalty 
		FROM titleauthor
		INNER JOIN sales
		ON sales.title_id = titleauthor.title_id
		INNER JOIN titles 
		ON titles.title_id = titleauthor.title_id) as author_loyalty
	GROUP BY au_id, title_id, advance) AS author_profit

GROUP BY au_id, profits
ORDER BY profits desc
limit 3;

-- Challenge 2 - ALTERNATIVE SOLUTION 

CREATE TEMPORARY TABLE royalty
SELECT titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100 / 100, 2) AS advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100, 2)
AS sales_loyalty 
FROM titleauthor
INNER JOIN sales
ON sales.title_id = titleauthor.title_id
INNER JOIN titles 
ON titles.title_id = titleauthor.title_id;


CREATE TEMPORARY TABLE total_royalties
SELECT title_id, au_id, sum(sales_loyalty) as sum_loyalty, advance
FROM
	(SELECT titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100 / 100, 2) AS advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100, 2)
	AS sales_loyalty 
	FROM titleauthor
	INNER JOIN sales
	ON sales.title_id = titleauthor.title_id
	INNER JOIN titles 
	ON titles.title_id = titleauthor.title_id) as author_loyalty
GROUP BY au_id, title_id, advance;


CREATE TEMPORARY TABLE total_profits
SELECT au_id, (advance + sum_loyalty) as profits
FROM
	(SELECT title_id, au_id, sum(sales_loyalty) as sum_loyalty, advance
	FROM
		(SELECT titleauthor.title_id, titleauthor.au_id, round(titles.advance * titleauthor.royaltyper / 100 / 100, 2) AS advance, round(titles.price * sales.qty * titles.royalty / 100 * titleauthor.royaltyper / 100, 2)
		AS sales_loyalty 
		FROM titleauthor
		INNER JOIN sales
		ON sales.title_id = titleauthor.title_id
		INNER JOIN titles 
		ON titles.title_id = titleauthor.title_id) as author_loyalty
	GROUP BY au_id, title_id, advance) AS author_profit

GROUP BY au_id, profits
ORDER BY profits desc
limit 3;

-- Challenge 3 - 
CREATE TABLE most_profiting_authors 
(au_id int auto_increment,
author_profit varchar (255) not null,
PRIMARY KEY au_id
);


