$(document).ready(() => {
  WordMap.init();
});

WordMap = {
  init: function() {

    $.ajax({
      method: 'get',
      url: '/word_map.json',
      success: (results) => {
        this.printCloud(results.words);
      }
    });
    this.width = 500;
    this.height = 500;

  },
  printCloud: function(words) {

    var width = this.width;
    var height = this.height;
    var drawSkillCloud = this.drawSkillCloud;

    d3.layout.cloud()
      .size([500, 500])
      .words(words)
      .rotate(function() {
        return ~~(Math.random() * 2) * 90;
      })
      .font("Impact")
      .fontSize(function(d) {
        return d.size;
      })
      .on("end", drawSkillCloud)
      .start();
  },
  drawSkillCloud: function(words) {

    var width = WordMap.width;
    var height = WordMap.height;
    var fill = d3.scale.category20();

    d3.select("#cloud").append("svg")
      .attr("width", width)
      .attr("height", height)
      .append("g")
      .attr("transform", "translate(" + ~~(width / 2) + "," + ~~(height / 2) + ")")
      .selectAll("text")
      .data(words)
      .enter().append("text")
      .style("font-size", function(d) {
        return d.size + "px";
      })
      .style("-webkit-touch-callout", "none")
      .style("-webkit-user-select", "none")
      .style("-khtml-user-select", "none")
      .style("-moz-user-select", "none")
      .style("-ms-user-select", "none")
      .style("user-select", "none")
      .style("cursor", "default")
      .style("font-family", "Impact")
      .style("fill", function(d, i) {
        return fill(i);
      })
      .attr("text-anchor", "middle")
      .attr("transform", function(d) {
        return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
      })
      .text(function(d) {
        return d.text;
      });
  }
}
