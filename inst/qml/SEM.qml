//
// Copyright (C) 2013-2018 University of Amsterdam
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public
// License along with this program.  If not, see
// <http://www.gnu.org/licenses/>.
//
import QtQuick			2.12
import JASP.Controls	1.0
import JASP.Widgets		1.0
import JASP				1.0
import "./common" as Common

Form
{

	columns: 1

	// The following part is used for spawning upgrade notifications about multigroup analysis
	Rectangle
	{
		visible:		myAnalysis !== null && myAnalysis.needsRefresh && grpvar.currentIndex !== 0 // if groupvar index is 0, there is no grouping variable -> no multigroup analysis
		color:			jaspTheme.controlWarningBackgroundColor
		width:			form.implicitWidth
		height:			warningMessageUpdate.height
		radius:			jaspTheme.borderRadius

		Text
		{
			id:					warningMessageUpdate
			text:				qsTr("This analysis was created with an older version of JASP (or a dynamic module). Since then, there were changes in the lavaan package that runs the analysis. Specifically, the lavaan syntax for equality constraints in multigroup analysis is now interpreted differently. Proceed with caution! More details about the update can be found at https://groups.google.com/g/lavaan/c/HSavF8oaW5M")
			color:				jaspTheme.controlWarningTextColor
			anchors.top:		parent.top
			padding:			5 * jaspTheme.uiScale
			wrapMode:			Text.Wrap
			width:				parent.width - 10 * jaspTheme.uiScale
			verticalAlignment:	Text.AlignVCenter
		}
	}
	// end upgrade notifications

	TabView
	{
		id: models
		name: "models"
		maximumItems: 9
		newItemName: qsTr("Model 1")
		optionKey: "name"

		content: TextArea { name: "syntax"; width: models.width; textType: JASP.TextTypeLavaan }
	}

	RadioButtonGroup
	{
		title: qsTr("Data")
		name: "dataType"
		columns: 2
		RadioButton { value: "raw"; label: qsTr("Raw"); checked: true }
		RadioButton
		{
			value: "varianceCovariance"; label: qsTr("Variance-covariance matrix")
			IntegerField { name: "sampleSize"; label: qsTr("Sample size"); defaultValue: 0 }
		}
	}

	DropDown
	{
		name: "samplingWeights"
		label: qsTr("Sampling weights")
		showVariableTypeIcon: true
		addEmptyValue: true
	}

	Section
	{
		title: qsTr("Model")
		Group
		{
			DropDown
			{
				name: "factorScaling"
				label: qsTr("Factor scaling")
				values:
				[
					{ label: qsTr("Factor loadings")	, value: "factorLoading"	},
					{ label: qsTr("Factor variance")	, value: "factorVariance"			},
					{ label: qsTr("Effects coding")		, value: "effectCoding"	},
					{ label: qsTr("None")				, value: "none"				}
				]
			}
			CheckBox { name: "meanStructure";					label: qsTr("Include mean structure")							}
			CheckBox { name: "manifestInterceptFixedToZero";	label: qsTr("Fix manifest intercepts to zero")					}
			CheckBox { name: "latentInterceptFixedToZero";		label: qsTr("Fix latent intercepts to zero");	checked: true	}
			CheckBox { name: "orthogonal";						label: qsTr("Assume factors uncorrelated")						}
		}

		Group
		{

			CheckBox { name: "exogenousCovariateFixed";			label: qsTr("Fix exogenous covariates"); 		checked: true	}
			CheckBox { name: "residualSingleIndicatorOmitted";	label: qsTr("Omit residual single indicator");	checked: true	}
			CheckBox { name: "residualVariance";				label: qsTr("Include residual variances");		checked: true	}
			CheckBox { name: "exogenousLatentCorrelation";		label: qsTr("Correlate exogenous latents");		checked: true	}
			CheckBox { name: "dependentCorrelation";			label: qsTr("Correlate dependent variables");	checked: true	}
			CheckBox { name: "threshold";						label: qsTr("Add thresholds");					checked: true	}
			CheckBox { name: "scalingParameter";				label: qsTr("Add scaling parameters");			checked: true	}
			CheckBox { name: "efaConstrained";					label: qsTr("Constrain EFA blocks");			checked: true	}
		}
	}

	Section
	{
		title: qsTr("Output")

		Group
		{
			CheckBox { name: "additionalFitMeasures";	label: qsTr("Additional fit measures")	}
			CheckBox { name: "rSquared";				label: qsTr("R-squared")				}
			CheckBox { name: "observedCovariance";		label: qsTr("Observed covariances")		}
			CheckBox { name: "impliedCovariance";		label: qsTr("Implied covariances")		}
			CheckBox { name: "residualCovariance";		label: qsTr("Residual covariances")		}
			CheckBox { name: "standardizedResidual"; 	label: qsTr("Standardized residuals")	}
			CheckBox { name: "mardiasCoefficient";		label: qsTr("Mardia's coefficient")		}
		}
		Group
		{
			CheckBox
			{
				name: "standardizedEstimate"
				id: stdest
				label: qsTr("Standardized estimates")
				checked: false
				RadioButtonGroup
				{
					name: "standardizedEstimateType"
					RadioButton { value: "all"; 	label: qsTr("All"); checked: true	}
					RadioButton { value: "latents"; label: qsTr("Latents")	}
					RadioButton { value: "noX"; 	label: qsTr("no X")		}
				
				}
			}
			
			CheckBox
			{
				name: "pathPlot";
				text: qsTr("Path diagram");
				checked: false
				CheckBox {
					name: "pathPlotParameter"
					text: qsTr("Show parameter estimates")
					checked: false
				}
				CheckBox {
					name: "pathPlotLegend"
					text: qsTr("Show legend")
					checked: false
				}
			}
			CheckBox
			{
				name: "modificationIndex"
				label: qsTr("Modification indices")
				CheckBox
				{
					name: "modificationIndexHiddenLow"
					label: qsTr("Hide low indices")
					DoubleField
					{
						name: "modificationIndexThreshold"
						label: qsTr("Threshold")
						negativeValues: false
						decimals: 2
						defaultValue: 10
					}
				}
			}
		}

	}

	Common.Estimation {	}

	Section
	{
		title: qsTr("Multigroup")
		id: multigroup
		Group
		{
			DropDown
			{
				id: grpvar
				name: "group"
				label: qsTr("Grouping Variable")
				showVariableTypeIcon: true
				addEmptyValue: true
			} // No model or source: it takes all variables per default
			Group
			{
				id: constraints
				title: qsTr("Equality Constraints")
				CheckBox { id: eq_loadings; 			name: "equalLoading";				label: qsTr("Loadings")				}
				CheckBox { id: eq_intercepts; 			name: "equalIntercept";				label: qsTr("Intercepts")			}
				CheckBox { id: eq_residuals; 			name: "equalResidual";				label: qsTr("Residuals")			}
				CheckBox { id: eq_residualcovariances; 	name: "equalResidualCovariance";	label: qsTr("Residual covariances")	}
				CheckBox { id: eq_means; 				name: "equalMean";					label: qsTr("Means")				}
				CheckBox { id: eq_thresholds; 			name: "equalThreshold";				label: qsTr("Threshold")			}
				CheckBox { id: eq_regressions; 			name: "equalRegression";			label: qsTr("Regressions")			}
				CheckBox { id: eq_variances; 			name: "equalLatentVariance";		label: qsTr("Latent variances")		}
				CheckBox { id: eq_lvcovariances; 		name: "equalLatentCovariance";		label: qsTr("Latent covariances")	}
			}

		}
		TextArea
		{
			name: "freeParameters"
			title: qsTr("Release constraints (one per line)")
			width: multigroup.width / 2
			height: constraints.height + grpvar.height
			textType: JASP.TextTypeLavaan
			visible: eq_loadings.checked || eq_intercepts.checked || eq_residuals.checked || eq_residualcovariances.checked || eq_means.checked || eq_thresholds.checked || eq_regressions.checked || eq_variances.checked || eq_lvcovariances.checked
		}
	}
}
