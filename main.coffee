
{table, thead, tbody, tr, th, td, span, form, input, p , div} = React.DOM

ProductCategoryRow = React.createClass
  render: ->
    tr null, 
      th colSpan: 2, this.props.category

ProductRow = React.createClass
  render: -> 
    if this.props.product.stocked
      name = this.props.product.name
    else 
      name = R.span style: color:'red', this.props.product.name

    return(
      tr( null, 
        td null, name
        td null, this.props.product.price)
    )


ProductTable = React.createClass
  render: -> 
    rows = []
    lastCategory = null
    this.props.products.forEach (product) =>

      if product.name.indexOf(@props.filterText) == -1 or (!product.stocked && @props.inStockOnly)
        return

      if product.category != lastCategory
        rows.push ProductCategoryRow category: product.category, key: product.category
      
      rows.push ProductRow product: product, key: product.name
      lastCategory = product.category
    return (
      table null, 
        thead null,
          tr( null, 
            th null, 'Name'
            th null, 'Price')
        tbody null, rows
      )


SearchBar = React.createClass
  render: ->
    return (
      form null,
        input type:'text', placeholder: @props.filterText, onChange: @handleChange, ref: 'filterTextInput'
        p null, 
          input type: 'checkbox', value: @props.inStockOnly, onChange: @handleChange, ref: 'inStockOnlyInput', 'Only show products in stock'
    )

  handleChange: -> 
    this.props.onUserInput(
      @refs.filterTextInput.getDOMNode().value
      @refs.inStockOnlyInput.getDOMNode().checked
    )


FilterableProductTable = React.createClass
  getInitialState: -> 
    filterText: '',
    inStockOnly: false

  handleUserInput: (filterText, inStockOnly) ->
    @setState
      filterText: filterText
      inStockOnly: inStockOnly

  render: -> 
    return (
      div null,
        SearchBar 
          filterText: @state.filterText,
          inStockOnly: @state.inStockOnly
          onUserInput: @handleUserInput
        ProductTable
          products: @props.products
          filterText: @state.filterText,
          inStockOnly: @state.inStockOnly
    )


PRODUCTS = [
  {category: 'Sporting Goods', price: '$49.99', stocked: true, name: 'Football'},
  {category: 'Sporting Goods', price: '$9.99', stocked: true, name: 'Baseball'},
  {category: 'Sporting Goods', price: '$29.99', stocked: false, name: 'Basketball'},
  {category: 'Electronics', price: '$99.99', stocked: true, name: 'iPod Touch'},
  {category: 'Electronics', price: '$399.99', stocked: false, name: 'iPhone 5'},
  {category: 'Electronics', price: '$199.99', stocked: true, name: 'Nexus 7'}
]


React.renderComponent FilterableProductTable(products: PRODUCTS), document.getElementById('content')


