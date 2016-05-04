defmodule GildedRoseTest do
  use ExUnit.Case, async: true

  test "update_items" do
    list = [
      %Item{name: "Elixir of the Mongoose", sell_in: 1, quality: 10}
    ]

    expected = [
      %Item{name: "Elixir of the Mongoose", sell_in: 0, quality: 9}
    ]

    assert GildedRose.update_items(list) == expected
  end

  test "items reduce in quality" do
    item = %Item{name: "Elixir of the Mongoose", sell_in: 1, quality: 10}
    assert GildedRose.update_item(item).quality == 9
  end

  test "items past sellin date degrades twice" do
    mongoose = %Item{name: "Elixir of the Mongoose", sell_in: -1, quality: 10}
    dex = %Item{name: "+5 Dexterity Vest", sell_in: -1, quality: 10}

    assert GildedRose.update_item(mongoose).quality == 8
    assert GildedRose.update_item(dex).quality == 8
  end

  test "item cannot exceed 50 quality" do
    aged_brie = %Item{name: "Aged Brie", quality: 50, sell_in: 10}
    assert GildedRose.update_item(aged_brie).quality == 50
    
    pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", quality: 49, sell_in: 10}
    assert GildedRose.update_item(pass).quality == 50
  end

  test "item quality is never negative" do
    broken_item = %Item{sell_in: 5, quality: 0}
    assert GildedRose.update_item(broken_item).quality == 0
  end

  test "aged brie increases in quality" do
    aged_brie = %Item{name: "Aged Brie", quality: 40, sell_in: 10}
    assert GildedRose.update_item(aged_brie).quality == 41
  end

  test "Sulfuras cannot be sold or decreases in quality" do
    sulfuras = %Item{name: "Sulfuras, Hand of Ragnaros", quality: 80, sell_in: 10}
    assert GildedRose.update_item(sulfuras) == sulfuras
  end

  test "backstage" do
    pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", quality: 1, sell_in: 11}
    assert GildedRose.update_item(pass).quality == 2

    pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", quality: 1, sell_in: 10}
    assert GildedRose.update_item(pass).quality == 3

    pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", quality: 1, sell_in: 1}
    assert GildedRose.update_item(pass).quality == 4

    pass = %Item{name: "Backstage passes to a TAFKAL80ETC concert", quality: 2, sell_in: -1}
    assert GildedRose.update_item(pass).quality == 0
  end

  test "conjured" do
    conjured = %Item{name: "Conjured Wat", quality: 2, sell_in: 2}
    assert GildedRose.update_item(conjured).quality == 0

    conjured = %Item{name: "Conjured Wat", quality: 4, sell_in: -2}
    assert GildedRose.update_item(conjured).quality == 0

    conjured = %Item{name: "Conjured Wat", quality: 2, sell_in: -2}
    assert GildedRose.update_item(conjured).quality == 0
  end
end
