import SwiftUI

struct MealCardView: View {
    let meal: Meal
    let mode: MealMode
    let weight: Double
    let lang: AppLanguage
    var colors: ThemeColorSet = Theme.colors(for: .dark)

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacing8) {
            // Eyebrow badge
            Text((mode == .quick ? L10n.quick(lang) : L10n.cooked(lang)).uppercased())
                .font(.eyebrowMicro)
                .foregroundColor(colors.text3)
                .tracking(0.14 * 9)

            // Meal name
            Text(meal.name.uppercased())
                .font(.headingLarge)
                .foregroundColor(colors.text)
                .tracking(0.02 * 20)
                .fixedSize(horizontal: false, vertical: true)

            // Ingredients
            VStack(alignment: .leading, spacing: Theme.spacing4) {
                ForEach(meal.scaledIngredients(for: weight)) { ingredient in
                    HStack(spacing: Theme.spacing4) {
                        Text("·")
                            .foregroundColor(colors.text3)
                        Text("\(ingredient.displayAmount()) \(ingredient.item)")
                            .font(.ingredientText)
                            .foregroundColor(colors.text2)
                    }
                }
            }

            Spacer(minLength: 0)

            // Kcal — large lime number
            HStack(alignment: .firstTextBaseline, spacing: Theme.spacing4) {
                Text("~\(meal.scaledKcal(for: weight))")
                    .font(.headingLarge)
                    .foregroundColor(Theme.accent)
                    .tracking(-0.3)
                Text("kcal")
                    .font(.ingredientText)
                    .foregroundColor(colors.text3)
            }
            .padding(.top, Theme.spacing4)
        }
        .padding(Theme.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.surface)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(colors.border, lineWidth: Theme.cardBorderWidth)
        )
        .cornerRadius(Theme.cornerRadius)
    }
}
