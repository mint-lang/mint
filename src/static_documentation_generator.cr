module Mint
  # This class generates static API documentation (HTML files).
  module StaticDocumentationGenerator
    extend self

    alias TopLevelEntity = DocumentationGenerator::TopLevelEntity
    alias Entity = DocumentationGenerator::Entity
    alias Kind = DocumentationGenerator::Kind

    def generate(asts : Array(Ast)) : Hash(String, Proc(String))
      ast =
        asts
          .reduce(Ast.new) { |memo, item| memo.merge(item) }
          .tap(&.normalize)

      entities =
        DocumentationGenerator.resolve(ast)

      entities
        .map { |entity| generate(entity, entities) }
        .to_h
        .tap do |files|
          files["index.html"] =
            ->do
              layout "API Documentation", entities do
                article do
                  h1 do
                    text "API Documentation"
                  end
                end
              end
            end

          Assets.files.each do |file|
            next unless file.path.starts_with?("/docs/")

            contents =
              file.gets_to_end

            files[file.path.lchop("/docs/")] = ->{ contents }
          end
        end
    end

    def generate(
      entity : TopLevelEntity,
      entities : Array(TopLevelEntity)
    ) : {String, Proc(String)}
      {
        href(entity),
        ->do
          layout entity.name, entities do |builder|
            article do
              h1 do
                if flags = entity.flags
                  flags.each do |flag|
                    case flag
                    in .global?
                      span class: "keyword" { text "global " }
                    in .async?
                      span class: "keyword" { text "async " }
                    end
                  end
                end

                span class: "keyword" { text "#{kind(entity.kind)} " }
                span { text entity.name }

                if parameters = entity.parameters
                  span { text "(" }

                  parameters
                    .intersperse(", ")
                    .each { |param| span { text param } }

                  span { text ")" }
                end
              end

              if description = entity.description
                div class: "content" do
                  raw description
                end
              end

              if sub_entities = entity.entities
                sub_entities.sort_by(&.name).each do |item|
                  div class: "entity" do
                    a name: item.name, id: item.name

                    entity_signature item, builder

                    if description = item.description
                      div class: "content" do
                        raw description
                      end
                    end
                  end
                end
              end
            end

            nav do
              strong { text "ON THIS PAGE" }

              entity.entities.try(&.each do |item|
                link item, builder
              end)
            end
          end
        end,
      }
    end

    def entity_signature(
      entity : Entity,
      builder : HtmlBuilder
    )
      head = ->do
        builder.span class: "keyword" { text "#{kind(entity.kind)} " }
        builder.a href: "##{entity.name}" { text entity.name }
      end

      type = ->do
        if value = entity.type
          builder.span { text " : " }
          builder.raw value
        end
      end

      arguments = entity.arguments.try do |items|
        ->do
          items.each_with_index do |argument, index|
            builder.div class: "argument" do
              span { text argument.name }

              if value = argument.type
                span { text " : " }
                raw value
              end

              if value = argument.value
                span { text " = " }
                raw value
              end

              if index < (items.size - 1)
                span { text ", " }
              end
            end
          end
        end
      end

      builder.div class: "entity-signature" do
        if entity.broken?
          if arguments
            div do
              head.call
              text " ("
            end

            arguments.call

            div do
              text ")"
              type.call
            end
          else
            div do
              head.call
              type.call
            end
          end
        else
          head.call

          if arguments
            text " ("
            arguments.call
            text ")"
          end

          type.call
        end

        if value = entity.value
          div do
            span { text " = " }
            raw value
          end
        end
      end
    end

    def badge(value : Kind)
      case value
      in .provider?
        {"P", "var(--color-darkmagenta)"}
      in .property?
        {"P", "var(--color-darkorange)"}
      in .module?
        {"M", "var(--color-darkorange)"}
      in .signal?
        {"S", "var(--color-indianred)"}
      in .state?
        {"S", "var(--color-indianred)"}
      in .type?
        {"T", "var(--color-royalblue)"}
      in .get?
        {"G", "var(--color-royalblue)"}
      in .function?
        {"F", "var(--color-mintgreen)"}
      in .type_field?
        {"F", "var(--color-royalblue)"}
      in .component?
        {"C", "var(--color-mintgreen)"}
      in .store?
        {"S", "var(--color-crimson)"}
      in .constant?
        {"C", "var(--text-color)"}
      end
    end

    def kind(value : Kind)
      case value
      in .type_field?
        ""
      in .component?
        "component"
      in .provider?
        "provider"
      in .property?
        "property"
      in .function?
        "fun"
      in .constant?
        "const"
      in .module?
        "module"
      in .signal?
        "signal"
      in .store?
        "store"
      in .state?
        "state"
      in .type?
        "type"
      in .get?
        "get"
      end
    end

    def href(entity)
      case entity.kind
      when .type?
        "#{entity.name}(type).html"
      else
        "#{entity.name}.html"
      end
    end

    def link(item, builder)
      char, color =
        badge(item.kind)

      href =
        case item
        in TopLevelEntity
          href(item)
        in Entity
          "##{item.name}"
        end

      builder.a href: href, class: "link" do
        span class: "badge", style: "background: #{color}" do
          text char
        end

        text item.name
      end
    end

    def layout(title : String, entities : Array(TopLevelEntity), &) : String
      HtmlBuilder.build(optimize: true) do |builder|
        html do
          head do
            meta charset: "utf-8"
            link rel: "stylesheet", href: "../style.css"

            title do
              text title
            end
          end

          body do
            aside do
              entities.sort_by(&.name).each do |entity|
                link entity, builder
              end
            end

            with builder yield builder
          end
        end
      end
    end
  end
end
