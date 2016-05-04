defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 3}]
  @degradation_rate 1
  @max_quality 50
  @min_quality 0

  def update_items(list), do: Enum.map(list, &update_item/1)

  def update_item(item = %{name: "Conjured" <> _rest, sell_in: sell_in}) when sell_in < 0 do
    %Item{item | quality: degrade_quality(item.quality, 4), sell_in: sell_in - 1}
  end
  def update_item(item = %{name: "Conjured" <> _rest}) do
    %Item{item | quality: degrade_quality(item.quality, 2), sell_in: item.sell_in - 1}
  end

  def update_item(item = %{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in}) 
    when sell_in < 0 do
    %Item{item | quality: 0, sell_in: item.sell_in - 1}
  end
  def update_item(item = %{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in}) 
    when sell_in <= 5 do
    %Item{item | quality: upgrade_quality(item.quality, 3), sell_in: item.sell_in - 1}
  end
  def update_item(item = %{ name: "Backstage passes to a TAFKAL80ETC concert", sell_in: sell_in }) 
    when sell_in <= 10 do
    %Item{item | quality: upgrade_quality(item.quality, 2), sell_in: item.sell_in - 1}
  end

  def update_item(item = %{name: "Sulfuras, Hand of Ragnaros"}), do: item

  def update_item(item = %{name: name}) 
    when name == "Aged Brie" or name == "Backstage passes to a TAFKAL80ETC concert" do
    %Item{item | quality: upgrade_quality(item.quality), sell_in: item.sell_in - 1}
  end

  def update_item(item = %{quality: quality, sell_in: sell_in}) when sell_in < 0 do
    %Item{item | quality: degrade_quality(quality, 2), sell_in: sell_in - 1}
  end

  def update_item(item) do
    %Item{item | quality: degrade_quality(item.quality), sell_in: item.sell_in - 1}
  end

  defp upgrade_quality(quality, multiplier \\ 1)
  defp upgrade_quality(50, _multiplier), do: 50
  defp upgrade_quality(quality, multiplier) do
    case quality + (@degradation_rate * multiplier) do
      x when x < 50 -> x
      _ -> 50
    end
  end

  defp degrade_quality(quality, multiplier \\ 1)
  defp degrade_quality(0, _multiplier), do: 0
  defp degrade_quality(quality, multiplier) do
    case quality - (@degradation_rate * multiplier) do
      x when x > 0 -> x
      _ -> 0
    end
  end
end
