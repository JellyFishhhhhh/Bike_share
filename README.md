# Cyclistic Project
The director of marketing at Cyclistic, a fictional bike-share company in Chicago, believes the company's future success depends on maximizing the number of annual memberships. The goal of this case study is to understand how casual riders and annual members use Cyclistic bikes differently. From those insights, the company will design a new marketing strategy to convert casual riders into annual members.


[The data 2024/01 - 2024/06](https://divvy-tripdata.s3.amazonaws.com/index.html)

[Some thoughts (html format)](https://htmlpreview.github.io/?https://github.com/JellyFishhhhhh/Bike_share/blob/main/bike_share.html)

<!-- 
This <script> tag links to the Embedding API library as a JavaScript ES6 module. 
To use the library in your web application, you need to set the type attribute to 
module in the <script> tag. 
-->

<script type="module" src="https://public.tableau.com/javascripts/api/tableau.embedding.3.latest.min.js"></script>

<!-- 
Initialize the API as part of your HTML code by using the <tableau-viz> web component. 
After linking to the API library, the following code is all you need to embed a Tableau view into your HTML pages.
-->

<tableau-viz id="tableauViz"       
  src='https://public.tableau.com/views/Superstore_24/Overview'      
  height='600px' width='600px' toolbar='bottom' hide-tabs>
</tableau-viz>
