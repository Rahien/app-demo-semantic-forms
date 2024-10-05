(in-package :mu-cl-resources)

(setf *include-count-in-paginated-responses* t)
(setf *supply-cache-headers-p* t)
(setf sparql:*experimental-no-application-graph-for-sudo-select-queries* t)
(setf *cache-model-properties-p* t)

(define-resource persoon ()
  :class (s-prefix "person:Person")
  :properties `((:achternaam :string ,(s-prefix "foaf:familyName"))
                (:alternatieve-naam :string ,(s-prefix "foaf:name"))
                (:gebruikte-voornaam :string ,(s-prefix "persoon:gebruikteVoornaam"))
                (:possible-duplicate :boolean ,(s-prefix "ext:possibleDuplicate"))
                (:modified :datetime ,(s-prefix "dct:modified")))
  :has-one `((geboorte :via ,(s-prefix "persoon:heeftGeboorte")
                       :as "geboorte")
             (identificator :via ,(s-prefix "adms:identifier")
                            :as "identificator")
             (geslacht-code :via ,(s-prefix "persoon:geslacht")
                            :as "geslacht"))
  :resource-base (s-url "http://data.lblod.info/id/personen/")
  :features '(include-uri)
  :on-path "personen")

(define-resource geslacht-code ()
  :class (s-prefix "ext:GeslachtCode")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :resource-base (s-url "http://data.vlaanderen.be/id/concept/GeslachtCode/")
  :features '(include-uri)
  :on-path "geslacht-codes")

(define-resource identificator ()
  :class (s-prefix "adms:Identifier")
  :properties `((:identificator :string ,(s-prefix "skos:notation"))) ;; TODO: should have a specific type
  :resource-base (s-url "http://data.lblod.info/id/identificatoren/")
  :features '(include-uri)
  :on-path "identificatoren")

(define-resource geboorte ()
  :class (s-prefix "persoon:Geboorte")
  :properties `((:datum :date ,(s-prefix "persoon:datum")))
  :resource-base (s-url "http://data.lblod.info/id/geboortes/")
  :features '(include-uri)
  :on-path "geboortes")


(define-resource gebruiker ()
  :class (s-prefix "foaf:Person")
  :resource-base (s-url "http://data.lblod.info/id/gebruiker/")
  :properties `((:voornaam :string ,(s-prefix "foaf:firstName"))
                (:achternaam :string ,(s-prefix "foaf:familyName"))
                (:rijksregister-nummer :string ,(s-prefix "dct:identifier")))
  :has-many `((account :via ,(s-prefix "foaf:account")
                       :as "account")
              (bestuurseenheid :via ,(s-prefix "foaf:member")
                              :as "bestuurseenheden"))
  :on-path "gebruikers"
)

(define-resource account ()
  :class (s-prefix "foaf:OnlineAccount")
  :resource-base (s-url "http://data.lblod.info/id/account/")
  :properties `((:provider :via ,(s-prefix "foaf:accountServiceHomepage"))
                (:vo-id :via ,(s-prefix "dct:identifier")))
  :has-one `((gebruiker :via ,(s-prefix "foaf:account")
                         :inverse t
                         :as "gebruiker"))
  :on-path "accounts"
)

(define-resource bestuurseenheid () ;; Subclass of m8g:PublicOrganisation, which is a subclass of dct:Agent
  :class (s-prefix "besluit:Bestuurseenheid")
  :properties `((:naam :string ,(s-prefix "skos:prefLabel"))
                (:alternatieve-naam :string-set ,(s-prefix "skos:altLabel"))
                (:wil-mail-ontvangen :boolean ,(s-prefix "ext:wilMailOntvangen")) ;;Voorkeur in berichtencentrum
                (:mail-adres :string ,(s-prefix "ext:mailAdresVoorNotificaties"))
                (:is-trial-user :boolean ,(s-prefix "ext:isTrailUser"))
                (:view-only-modules :string-set ,(s-prefix "ext:viewOnlyModules")))
  :resource-base (s-url "http://data.lblod.info/id/bestuurseenheden/")
  :features '(include-uri)
  :on-path "bestuurseenheden"
)

(define-resource concept-scheme ()
  :class (s-prefix "skos:ConceptScheme")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((concept :via ,(s-prefix "skos:inScheme")
                       :inverse t
                       :as "concepts")
              (concept :via ,(s-prefix "skos:topConceptOf")
                       :inverse t
                       :as "top-concepts"))
  :resource-base (s-url "http://lblod.data.gift/concept-schemes/")
  :features `(include-uri)
  :on-path "concept-schemes"
)

(define-resource concept ()
  :class (s-prefix "skos:Concept")
  :properties `((:label :string ,(s-prefix "skos:prefLabel")))
  :has-many `((concept-scheme :via ,(s-prefix "skos:inScheme")
                              :as "concept-schemes")
              (concept-scheme :via ,(s-prefix "skos:topConceptOf")
                              :as "top-concept-schemes"))
  :resource-base (s-url "http://lblod.data.gift/concepts/")
  :features `(include-uri)
  :on-path "concepts"
)
