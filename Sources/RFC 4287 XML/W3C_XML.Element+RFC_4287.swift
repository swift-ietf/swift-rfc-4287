public import RFC_4287
import RFC_2822
import RFC_3339
import RFC_3987
import RFC_5646
import RFC_9110
public import W3C_XML

extension W3C_XML.Document {
    public init(_ feed: RFC_4287.Feed) throws(W3C_XML.Parse.Error) {
        self.init(declaration: W3C_XML.Declaration(version: .v1_0, encoding: "UTF-8"), root: try W3C_XML.Element(feed))
    }
}

extension W3C_XML.Element {
    public init(_ feed: RFC_4287.Feed) throws(W3C_XML.Parse.Error) {
        var content: [W3C_XML.Element] = feed.authors.map { W3C_XML.Element(atom: "author", $0.person) }
        content += feed.categories.map(W3C_XML.Element.init)
        content += feed.contributors.map { W3C_XML.Element(atom: "contributor", $0.person) }
        content += [feed.generator.map(W3C_XML.Element.init)].compactMap(\.self)
        content += [feed.icon.map { W3C_XML.Element(atom: "icon", $0.description) }].compactMap(\.self)
        content.append(W3C_XML.Element(atom: "id", feed.id.description))
        content += feed.links.map(W3C_XML.Element.init)
        content += [feed.logo.map { W3C_XML.Element(atom: "logo", $0.description) }].compactMap(\.self)
        content += [try feed.rights.map { rights throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "rights", rights.text) }].compactMap(\.self)
        content += [try feed.subtitle.map { subtitle throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "subtitle", subtitle.text) }].compactMap(\.self)
        content.append(try W3C_XML.Element(atom: "title", feed.title.text))
        content.append(W3C_XML.Element(atom: "updated", feed.updated.description))
        for entry in feed.entries { content.append(try W3C_XML.Element(entry)) }
        self.init(
            name: "feed",
            attributes: W3C_XML.Attribute.common(base: feed.base, lang: feed.lang),
            content: content.map(W3C_XML.Content.element),
            namespaces: [W3C_XML.Namespace(uri: "http://www.w3.org/2005/Atom")]
        )
    }

    public init(_ entry: RFC_4287.Entry) throws(W3C_XML.Parse.Error) {
        var content: [W3C_XML.Element] = entry.authors.map { W3C_XML.Element(atom: "author", $0.person) }
        content += entry.categories.map(W3C_XML.Element.init)
        content += [try entry.content.map { content throws(W3C_XML.Parse.Error) in try W3C_XML.Element(content) }].compactMap(\.self)
        content += entry.contributors.map { W3C_XML.Element(atom: "contributor", $0.person) }
        content.append(W3C_XML.Element(atom: "id", entry.id.description))
        content += entry.links.map(W3C_XML.Element.init)
        content += [entry.published.map { W3C_XML.Element(atom: "published", $0.description) }].compactMap(\.self)
        content += [try entry.rights.map { rights throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "rights", rights.text) }].compactMap(\.self)
        content += [try entry.source.map { source throws(W3C_XML.Parse.Error) in try W3C_XML.Element(source) }].compactMap(\.self)
        content += [try entry.summary.map { summary throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "summary", summary.text) }].compactMap(\.self)
        content.append(try W3C_XML.Element(atom: "title", entry.title.text))
        content.append(W3C_XML.Element(atom: "updated", entry.updated.description))
        self.init(name: "entry", attributes: W3C_XML.Attribute.common(base: entry.base, lang: entry.lang), content: content.map(W3C_XML.Content.element))
    }

    public init(_ source: RFC_4287.Source) throws(W3C_XML.Parse.Error) {
        var content: [W3C_XML.Element] = source.authors.map { W3C_XML.Element(atom: "author", $0.person) }
        content += source.categories.map(W3C_XML.Element.init)
        content += source.contributors.map { W3C_XML.Element(atom: "contributor", $0.person) }
        content += [source.generator.map(W3C_XML.Element.init)].compactMap(\.self)
        content += [source.icon.map { W3C_XML.Element(atom: "icon", $0.description) }].compactMap(\.self)
        content += [source.id.map { W3C_XML.Element(atom: "id", $0.description) }].compactMap(\.self)
        content += source.links.map(W3C_XML.Element.init)
        content += [source.logo.map { W3C_XML.Element(atom: "logo", $0.description) }].compactMap(\.self)
        content += [try source.rights.map { rights throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "rights", rights.text) }].compactMap(\.self)
        content += [try source.subtitle.map { subtitle throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "subtitle", subtitle.text) }].compactMap(\.self)
        content += [try source.title.map { title throws(W3C_XML.Parse.Error) in try W3C_XML.Element(atom: "title", title.text) }].compactMap(\.self)
        content += [source.updated.map { W3C_XML.Element(atom: "updated", $0.description) }].compactMap(\.self)
        self.init(name: "source", attributes: W3C_XML.Attribute.common(base: source.base, lang: source.lang), content: content.map(W3C_XML.Content.element))
    }

    public init(atom name: String, _ person: RFC_4287.Person) {
        let content: [W3C_XML.Element?] = [
            W3C_XML.Element(atom: "name", person.name),
            person.uri.map { W3C_XML.Element(atom: "uri", $0.description) },
            person.email.map { W3C_XML.Element(atom: "email", $0.description) },
        ]
        self.init(name: name, attributes: W3C_XML.Attribute.common(base: person.base, lang: person.lang), content: content.compactMap { $0.map(W3C_XML.Content.element) })
    }

    public init(atom name: String, _ text: RFC_4287.Text) throws(W3C_XML.Parse.Error) {
        self.init(
            name: name,
            attributes: [W3C_XML.Attribute(name: "type", value: text.type.rawValue)] + W3C_XML.Attribute.common(base: text.base, lang: text.lang),
            content: text.type == .xhtml ? [.element(try W3C_XML.Element(xhtml: text.value))] : [.text(text.value)]
        )
    }

    public init(_ content: RFC_4287.Content) throws(W3C_XML.Parse.Error) {
        let type: String = switch content.type {
        case .text: "text"
        case .html: "html"
        case .xhtml: "xhtml"
        case .media(let media): media.description
        }
        var attributes = [W3C_XML.Attribute(name: "type", value: type)]
        attributes += [content.src.map { W3C_XML.Attribute(name: "src", value: $0.description) }].compactMap(\.self)
        attributes += W3C_XML.Attribute.common(base: content.base, lang: content.lang)
        let body: [W3C_XML.Content] = switch (content.type, content.value) {
        case (_, nil): []
        case (.xhtml, let value?): [.element(try W3C_XML.Element(xhtml: value))]
        case (_, let value?): [.text(value)]
        }
        self.init(name: "content", attributes: attributes, content: body)
    }

    public init(_ link: RFC_4287.Link) {
        var attributes = [W3C_XML.Attribute(name: "href", value: link.href.description)]
        attributes += [
            link.rel.map { W3C_XML.Attribute(name: "rel", value: $0.value) },
            link.type.map { W3C_XML.Attribute(name: "type", value: $0) },
            link.hreflang.map { W3C_XML.Attribute(name: "hreflang", value: $0) },
            link.title.map { W3C_XML.Attribute(name: "title", value: $0) },
            link.length.map { W3C_XML.Attribute(name: "length", value: "\($0)") },
        ].compactMap(\.self)
        attributes += W3C_XML.Attribute.common(base: link.base, lang: link.lang)
        self.init(name: "link", attributes: attributes)
    }

    public init(_ category: RFC_4287.Category) {
        var attributes = [W3C_XML.Attribute(name: "term", value: category.term)]
        attributes += [
            category.scheme.map { W3C_XML.Attribute(name: "scheme", value: $0.description) },
            category.label.map { W3C_XML.Attribute(name: "label", value: $0) },
        ].compactMap(\.self)
        attributes += W3C_XML.Attribute.common(base: category.base, lang: category.lang)
        self.init(name: "category", attributes: attributes)
    }

    public init(_ generator: RFC_4287.Generator) {
        var attributes = [
            generator.uri.map { W3C_XML.Attribute(name: "uri", value: $0.description) },
            generator.version.map { W3C_XML.Attribute(name: "version", value: $0) },
        ].compactMap(\.self)
        attributes += W3C_XML.Attribute.common(base: generator.base, lang: generator.lang)
        self.init(name: "generator", attributes: attributes, content: [.text(generator.value)])
    }

    init(atom name: String, _ text: String) {
        self.init(name: name, content: [.text(text)])
    }

    init(xhtml markup: String) throws(W3C_XML.Parse.Error) {
        var division = try W3C_XML.parse("<div>\(markup)</div>").root
        if division.children.count == 1, division.content.allSatisfy({ $0.element != nil || ($0.text?.allSatisfy(\.isWhitespace) ?? false) }), let only = division.children.first, only.name.local == "div" {
            division = only
        }
        division.namespaces = [W3C_XML.Namespace(uri: "http://www.w3.org/1999/xhtml")]
        self = division
    }
}

extension W3C_XML.Attribute {
    static func common(base: RFC_3987.IRI?, lang: RFC_5646.LanguageTag?) -> [Self] {
        [
            base.map { W3C_XML.Attribute(name: W3C_XML.Name(local: "base", prefix: "xml"), value: $0.description) },
            lang.map { W3C_XML.Attribute(name: W3C_XML.Name(local: "lang", prefix: "xml"), value: $0.description) },
        ].compactMap(\.self)
    }
}
