class OrderRequest{
  final String city;
  final String title;
  final String street;

  OrderRequest({
    required this.city,
    required this.title,
    required this.street,
  });

  Map<String, dynamic> toJson() =>{
    'City': city,
    'Title': title,
    'Street': street,
  };
}