1. What classes does each implementation include? Are the lists the same?
Each implementation includes the classes CartEntry, ShoppingCart, and Order. They also initialize the same way in each implementation.


2. Write down a sentence to describe each class.
CartEntry represents items you would have in your shopping cart and is initialized with a unit_price and a quantity. ShoppingCart holds all the items that someone would want to buy and creates a variable entries when it is initialized, which is an empty array. Order represents someone's purchase and creates an instance of ShoppingCart when it is initialized.


3. How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
Order has a compositional relationship to ShoppingCart and ShoppingCart has a compositional relationship to CartEntry. In Implementation A, Order also has a relationship to CartEntry because the method total_price calls the variables in CartEntry directly. There are no inheritance relationships in this example.


4. What data does each class store? How (if at all) does this differ between the two implementations?
ShoppingCart holds instances of CartEntry and Order holds one instance of ShoppingCart. 


5. What methods does each class have? How (if at all) does this differ between the two implementations?
In Implementation A, all classes have initialize methods and Order has one other method called total_price. In Implementation B, in addition to the initialization methods, CartEntry and ShoppingCart both have methods called price and Order has a method called total_price.


6. Consider the Order#total_price method. In each implementation:
  🔘Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
  In Implementation A, the logic to calculate price is totally contained in the Order class, while in Implementation B, Order delegates the calculation to ShoppingCart, which in turn delegates the calculation to CartEntry.

  🔘Does total_price directly manipulate the instance variables of other classes?
  In the first implementation, total_price does use the instance variable of both of the other classes, but in Implementation B it does not call on any of the instance variables at all. Instead it just calls the method price on ShoppingCart.


7. If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
If there is to be a discount for items bought in bulk, the code would need to be altered to apply a discount to the unit price if the quantity purchased was above a certain amount. This change would be much easier to make in Implementation B, as you could just alter the price method to accommodate the discount. In Implementation A, you would have to make a lot of adjustments because Order is specifically calling upon the unit_price and quantity variables in its calculation of total_price.


8. Which implementation better adheres to the single responsibility principle?
Implementation B adheres much better to the single responsibility principle because each class only knows minimal information about the other classes. 


* Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
Implementation B is also more loosely coupled because none of the classes know any information about the instance variables of the other classes. All Order knows in Implementation B is that it holds and instance of ShoppingCart and it has a method named price and all ShoppingCart knows is that it holds something that responds to the method price. In Implementation A, Order knows that it holds instances of ShoppingCart, that ShoppingCart has an instance variable entries and that it holds something that has the instance variables unit_price and quantity. Way more information than it needs to know!
