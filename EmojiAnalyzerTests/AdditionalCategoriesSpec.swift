import Quick
import Nimble
@testable import EmojiAnalyzer


class AdditionalCategoriesSpec: QuickSpec {
  override func spec() {
    
    describe("AnnotationCategories") {
      
      it("Contains annotaions and categories") {
        let s = AdditionalCategories.read(file: "Annotation Categories")
        expect(s).to(contain("#HikeAnnotation"))
        expect(s).to(contain("#Movement"))
      }
      
      it("should not contain colons") {
        let s = AdditionalCategories.read(file: "Annotation Categories")
        expect(s).notTo(contain("#;"))
      }
    }
    
  }
}
