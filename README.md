# Supermarket Sales: Digging into Retail Data with SQL

Hi! Welcome to my Supermarket Sales analysis project. 

As I'm preparing for Data Analyst internships, I wanted to move beyond basic `SELECT *` statements and really test my SQL logic. For this project, I took a dataset of 1,000 supermarket transactions and tried to answer the kinds of questions a real store manager would ask.

## What I Wanted to Find Out
Instead of just looking at total revenue, I wanted to dig into customer behavior and operational efficiency. I set out to figure out:
* Who are our big spenders vs. casual shoppers?
* When is the absolute busiest time of day for our cashiers?
* Which specific product lines are actually driving profits in different branch locations?

## The Technical Stuff (My SQL Playground)
I used **MySQL** (via VS Code) to write the queries. This project was a great sandbox for me to practice some heavier SQL concepts:
* **`CASE` Statements:** I used these to build my own customer segmentation (grouping transactions into Small, Medium, and High spenders).
* **Window Functions (`RANK()`):** This was the toughest but most rewarding part! I used `RANK() OVER (PARTITION BY branch)` to find the #1 most profitable product line specifically for *each* branch without losing the rest of my data.
* **CTEs (Common Table Expressions):** Used these to neatly compare individual branch ratings against the overall company average.

## What's in Here?
* `01_exploration_queries.sql` -> This file has all my queries, starting from basic data exploration and working up to the complex Level 6 logic. I left comments in the code so you can see my thought process!

Feel free to poke around the code. If you have any feedback on how I can optimize my queries, I'm always open to learning!
