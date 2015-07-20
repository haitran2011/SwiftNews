extension GDataXMLElement {
    func elementForChild(child: String) -> GDataXMLElement? {
        let children = elementsForName(child)
        
        if count(children) > 0 {
            return children.first as? GDataXMLElement
        }
        
        return nil
    }
    
    func valueForChild(child: String) -> String? {
        return elementForChild(child)?.stringValue()
    }
}
