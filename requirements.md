# Requirements Document: Maarg AI

## Introduction

Maarg AI is an AI-powered shared mobility platform designed for e-rickshaw transportation in Indian Tier-1 and Tier-2 cities. The platform addresses the inefficiency of empty trips that waste driver earnings and battery charge, while reducing passenger wait times and uncertainty through intelligent demand prediction, route optimization, and voice-first accessibility.

This specification targets the AI for Bharat hackathon (AI for Communities, Access & Public Impact track) with a focus on practical AI applications using Amazon Bedrock, Amazon Q, and Kiro orchestration.

## Glossary

- **Maarg_Platform**: The complete AI-powered mobility system including passenger app, driver app, and AI services
- **Passenger_App**: Mobile application used by riders to book and track shared e-rickshaw rides
- **Driver_App**: Mobile application used by e-rickshaw drivers to receive bookings and route suggestions
- **Demand_Prediction_Agent**: AI agent that forecasts passenger demand by location and time
- **Route_Optimization_Agent**: AI agent that calculates optimal pickup sequences to maximize earnings
- **Conversational_Booking_Agent**: AI agent powered by Amazon Q for voice-based ride booking
- **Dynamic_Pricing_Agent**: AI agent that calculates transparent fare bands based on demand
- **Safety_Anomaly_Agent**: AI agent that detects route deviations and safety concerns
- **Kiro_Orchestrator**: System that coordinates multiple AI agents and workflows
- **Shared_Ride**: E-rickshaw trip with multiple passengers traveling similar routes
- **Empty_Trip**: Driver journey without passengers that wastes battery and earnings
- **Demand_Hotspot**: Geographic area with predicted high passenger demand
- **Booking**: Confirmed passenger reservation for a shared ride
- **Trip**: Actual journey from driver going online to completing all passenger drop-offs

## Goals and Non-Goals

### Goals

- Reduce empty trip kilometers for e-rickshaw drivers by 30-40%
- Increase driver daily earnings through optimized route suggestions
- Reduce passenger wait times from 15-20 minutes to under 5 minutes
- Enable voice-first booking in Hindi and English for accessibility
- Demonstrate practical AI applications for shared mobility in Indian cities

### Non-Goals

- National-scale deployment (focus on 2-3 pilot routes initially)
- Complex payment gateway integration (cash/UPI QR codes sufficient for MVP)
- Uber-scale platform features (surge pricing, driver ratings, in-app payments)
- Private car or bike taxi services (e-rickshaw shared mobility only)
- Real-time traffic integration (use historical patterns for MVP)

## User Personas

### Rajesh - E-Rickshaw Driver

**Demographics**: 35 years old, drives shared e-rickshaw on fixed routes in Tier-2 city

**Pain Points**:
- Wastes 30-40% of battery on empty return trips
- Uncertain where to find passengers during off-peak hours
- Limited smartphone literacy, prefers simple interfaces
- Loses earnings to competitors who guess demand better

**Motivations**:
- Increase daily earnings from ₹600 to ₹800-900
- Reduce battery anxiety and charging costs
- Simple app that works on basic Android phone with spotty 4G

**Constraints**:
- Limited English proficiency (Hindi primary language)
- Basic smartphone (2-3 GB RAM, Android 10+)
- Intermittent mobile connectivity
- Cannot afford expensive data plans

### Priya - Daily Commuter

**Demographics**: 28 years old, uses shared e-rickshaws for last-mile connectivity

**Pain Points**:
- Uncertain wait times (10-20 minutes typical)
- No visibility into vehicle arrival or occupancy
- Difficulty communicating pickup location in crowded areas
- Safety concerns during evening commutes

**Motivations**:
- Reliable, predictable commute times
- Know vehicle location and estimated arrival
- Voice booking when hands are full or in noisy environments
- Affordable shared rides (₹20-40 per trip)

**Constraints**:
- Prefers Hindi for voice interactions
- Needs app to work on low-end Android devices
- Limited patience for complex booking flows
- Expects rides within 5-7 minutes

### City Coordinator - Future Persona

**Demographics**: Municipal transport planner or route operator

**Pain Points**:
- No data on actual demand patterns
- Cannot optimize route coverage
- Difficult to measure service quality

**Motivations**:
- Data-driven route planning
- Monitor driver and passenger satisfaction
- Identify underserved areas

**Constraints**:
- Limited technical expertise
- Needs simple dashboards
- Budget constraints for infrastructure

## Key Use Cases

### Passenger Flows

**UC1: Book Shared Ride**
1. Passenger opens app, sees nearby available e-rickshaws
2. Selects pickup and drop-off points on route
3. Views estimated arrival time and fare
4. Confirms booking
5. Receives driver details and live tracking link

**UC2: Check Arrival and Occupancy**
1. Passenger views live vehicle location on map
2. Sees estimated arrival time (updates every 30 seconds)
3. Views current occupancy (e.g., "2/6 seats filled")
4. Receives notification when vehicle is 2 minutes away

**UC3: Voice Booking**
1. Passenger taps microphone icon
2. Speaks in Hindi or English: "Mujhe Station Road se Market jaana hai"
3. Conversational agent confirms pickup and destination
4. Agent shows fare and confirms booking
5. Passenger receives booking confirmation

**UC4: Track Ride and Safety**
1. Passenger boards vehicle, marks "Trip Started"
2. App tracks live location during journey
3. Passenger can share live location with emergency contact
4. App detects significant route deviation and alerts passenger
5. Passenger marks "Trip Completed" on arrival

### Driver Flows

**UC5: Go Online and Receive Suggestions**
1. Driver opens app, taps "Go Online"
2. App shows current location and battery level
3. AI suggests optimal starting point based on demand prediction
4. Driver navigates to suggested hotspot
5. App displays incoming booking requests

**UC6: Accept and Optimize Trip**
1. Driver receives booking request with pickup location
2. Route Optimization Agent suggests pickup sequence for multiple bookings
3. Driver views optimized route on map
4. Driver accepts bookings and starts trip
5. App provides turn-by-turn navigation for pickups

**UC7: View Demand Hotspots**
1. Driver views heatmap of predicted demand
2. App highlights areas with high passenger demand in next 30 minutes
3. Driver navigates to hotspot during idle time
4. App notifies driver of new bookings in that area

**UC8: Earnings Analytics**
1. Driver views daily earnings summary
2. App shows comparison: earnings with AI vs. without AI suggestions
3. Driver sees empty kilometer percentage reduction
4. App displays weekly trends and peak earning hours

## Functional Requirements

### Requirement 1: Passenger Booking

**User Story**: As a passenger, I want to book shared e-rickshaw rides quickly, so that I can reach my destination without long wait times.

#### Acceptance Criteria

1. WHEN a passenger opens the app, THE Passenger_App SHALL display available e-rickshaws within 2 km radius
2. WHEN a passenger selects pickup and drop-off points, THE Passenger_App SHALL calculate and display estimated fare within 2 seconds
3. WHEN a passenger confirms booking, THE Maarg_Platform SHALL assign the booking to an optimal driver within 5 seconds
4. WHEN a booking is confirmed, THE Passenger_App SHALL display driver name, vehicle number, and estimated arrival time
5. WHEN a driver accepts the booking, THE Passenger_App SHALL enable live tracking of vehicle location

### Requirement 2: Voice-Based Booking

**User Story**: As a passenger, I want to book rides using voice commands in Hindi or English, so that I can book hands-free and in my preferred language.

#### Acceptance Criteria

1. WHEN a passenger taps the voice booking button, THE Conversational_Booking_Agent SHALL activate and listen for voice input
2. WHEN a passenger speaks pickup and destination in Hindi or English, THE Conversational_Booking_Agent SHALL extract location intents with 85% accuracy
3. WHEN location intents are ambiguous, THE Conversational_Booking_Agent SHALL ask clarifying questions in the same language
4. WHEN locations are confirmed, THE Conversational_Booking_Agent SHALL create a booking equivalent to manual entry
5. WHEN voice booking fails, THE Passenger_App SHALL provide fallback to manual location selection

### Requirement 3: Live Tracking and Safety

**User Story**: As a passenger, I want to track my ride in real-time and share my location, so that I feel safe during my journey.

#### Acceptance Criteria

1. WHEN a booking is active, THE Passenger_App SHALL display live vehicle location updated every 30 seconds
2. WHEN a vehicle is within 500 meters, THE Passenger_App SHALL send a notification to the passenger
3. WHEN a passenger starts a trip, THE Passenger_App SHALL enable emergency contact sharing with live location link
4. WHEN the Safety_Anomaly_Agent detects route deviation exceeding 500 meters, THE Passenger_App SHALL alert the passenger
5. WHEN a trip is completed, THE Passenger_App SHALL prompt the passenger to confirm safe arrival

### Requirement 4: Driver Trip Management

**User Story**: As a driver, I want to receive optimized trip suggestions, so that I can maximize my earnings and reduce empty trips.

#### Acceptance Criteria

1. WHEN a driver goes online, THE Driver_App SHALL display current location and battery level
2. WHEN a driver is idle, THE Route_Optimization_Agent SHALL suggest the nearest demand hotspot within 1 km
3. WHEN a driver receives multiple booking requests, THE Route_Optimization_Agent SHALL calculate optimal pickup sequence within 3 seconds
4. WHEN a driver accepts bookings, THE Driver_App SHALL display turn-by-turn navigation for all pickups
5. WHEN a driver completes a trip, THE Driver_App SHALL immediately suggest next optimal location

### Requirement 5: Demand Prediction

**User Story**: As a driver, I want to see predicted passenger demand, so that I can position myself in high-demand areas.

#### Acceptance Criteria

1. WHEN a driver views the demand map, THE Demand_Prediction_Agent SHALL display demand hotspots for the next 30 minutes
2. WHEN calculating demand, THE Demand_Prediction_Agent SHALL use historical trip data from the past 30 days
3. WHEN demand patterns change, THE Demand_Prediction_Agent SHALL update predictions every 10 minutes
4. WHEN a hotspot is identified, THE Driver_App SHALL display expected wait time and potential earnings
5. WHEN multiple drivers are near a hotspot, THE Maarg_Platform SHALL distribute demand predictions to avoid oversupply

### Requirement 6: Earnings Analytics

**User Story**: As a driver, I want to view my earnings and efficiency metrics, so that I can understand the impact of AI suggestions.

#### Acceptance Criteria

1. WHEN a driver completes a trip, THE Maarg_Platform SHALL calculate and record earnings, distance, and empty kilometers
2. WHEN a driver views analytics, THE Driver_App SHALL display daily earnings with comparison to previous week
3. WHEN displaying metrics, THE Driver_App SHALL show percentage reduction in empty trips
4. WHEN a driver follows AI suggestions, THE Maarg_Platform SHALL track suggestion acceptance rate and earnings correlation
5. WHEN a week is completed, THE Driver_App SHALL generate a weekly summary with peak earning hours

### Requirement 7: Dynamic Pricing

**User Story**: As a passenger, I want transparent and fair pricing, so that I can trust the fare calculation.

#### Acceptance Criteria

1. WHEN a passenger requests fare estimate, THE Dynamic_Pricing_Agent SHALL calculate fare based on distance and demand
2. WHEN calculating fare, THE Dynamic_Pricing_Agent SHALL use predefined fare bands (low, medium, high demand)
3. WHEN displaying fare, THE Passenger_App SHALL show fare breakdown (base fare, distance, demand adjustment)
4. WHEN demand is high, THE Dynamic_Pricing_Agent SHALL limit fare increase to maximum 1.5x base fare
5. WHEN fare is calculated, THE Maarg_Platform SHALL ensure the same fare is shown to passenger and driver

### Requirement 8: Route Optimization

**User Story**: As a driver, I want optimized pickup sequences for multiple passengers, so that I can serve more customers efficiently.

#### Acceptance Criteria

1. WHEN a driver has multiple pending bookings, THE Route_Optimization_Agent SHALL calculate the optimal pickup order
2. WHEN calculating pickup order, THE Route_Optimization_Agent SHALL minimize total distance while respecting passenger wait times
3. WHEN a new booking arrives during a trip, THE Route_Optimization_Agent SHALL recalculate the route within 2 seconds
4. WHEN displaying optimized route, THE Driver_App SHALL show estimated time for each pickup
5. WHEN a pickup is completed, THE Route_Optimization_Agent SHALL update the route for remaining passengers

### Requirement 9: Conversational AI Integration

**User Story**: As a passenger, I want natural language interaction for booking, so that I can communicate as I would with a human.

#### Acceptance Criteria

1. WHEN the Conversational_Booking_Agent processes voice input, THE Maarg_Platform SHALL use Amazon Q for intent extraction
2. WHEN extracting intents, THE Conversational_Booking_Agent SHALL support Hindi and English language inputs
3. WHEN a passenger uses mixed language (Hinglish), THE Conversational_Booking_Agent SHALL correctly parse the request
4. WHEN responding to passengers, THE Conversational_Booking_Agent SHALL use the same language as the input
5. WHEN a conversation fails after 3 attempts, THE Conversational_Booking_Agent SHALL escalate to manual booking flow

### Requirement 10: AI Agent Orchestration

**User Story**: As a system administrator, I want coordinated AI agent execution, so that the platform delivers consistent and reliable service.

#### Acceptance Criteria

1. WHEN a booking is created, THE Kiro_Orchestrator SHALL coordinate Demand_Prediction_Agent, Route_Optimization_Agent, and Dynamic_Pricing_Agent
2. WHEN agents execute, THE Kiro_Orchestrator SHALL ensure agents complete within 5 seconds total
3. WHEN an agent fails, THE Kiro_Orchestrator SHALL retry once and fallback to rule-based logic if retry fails
4. WHEN multiple agents need data, THE Kiro_Orchestrator SHALL cache shared data to reduce redundant queries
5. WHEN agent execution completes, THE Kiro_Orchestrator SHALL log all agent decisions for analytics and debugging

### Requirement 11: Data Collection and Learning

**User Story**: As a system administrator, I want to collect trip data and feedback, so that AI models can improve over time.

#### Acceptance Criteria

1. WHEN a trip is completed, THE Maarg_Platform SHALL record trip data including route, duration, earnings, and empty kilometers
2. WHEN a driver accepts or rejects an AI suggestion, THE Maarg_Platform SHALL log the decision and outcome
3. WHEN a passenger completes a trip, THE Passenger_App SHALL prompt for simple feedback (thumbs up/down)
4. WHEN collecting data, THE Maarg_Platform SHALL anonymize personally identifiable information
5. WHEN sufficient data is collected (minimum 1000 trips), THE Maarg_Platform SHALL enable model retraining

### Requirement 12: Offline Capability

**User Story**: As a driver, I want basic app functionality during connectivity loss, so that I can complete ongoing trips without interruption.

#### Acceptance Criteria

1. WHEN network connectivity is lost, THE Driver_App SHALL cache the current trip details and navigation route
2. WHEN offline, THE Driver_App SHALL allow drivers to mark pickups and drop-offs completed
3. WHEN offline, THE Driver_App SHALL queue location updates for sync when connectivity returns
4. WHEN connectivity is restored, THE Driver_App SHALL sync all queued data within 10 seconds
5. WHEN offline for more than 5 minutes, THE Driver_App SHALL display a warning about limited functionality

### Requirement 13: Admin Dashboard

**User Story**: As a city coordinator, I want to view system analytics, so that I can monitor service quality and identify improvements.

#### Acceptance Criteria

1. WHEN an admin logs in, THE Maarg_Platform SHALL display key metrics: active drivers, completed trips, average wait time
2. WHEN viewing analytics, THE Maarg_Platform SHALL show demand heatmaps by time of day and day of week
3. WHEN analyzing efficiency, THE Maarg_Platform SHALL display average empty trip percentage across all drivers
4. WHEN reviewing AI performance, THE Maarg_Platform SHALL show prediction accuracy and suggestion acceptance rates
5. WHEN exporting data, THE Maarg_Platform SHALL generate CSV reports with trip and earnings data

## Non-Functional Requirements

### Requirement 14: Performance

**User Story**: As a user, I want fast and responsive app interactions, so that I can complete bookings quickly.

#### Acceptance Criteria

1. WHEN a user opens the app, THE Maarg_Platform SHALL load the home screen within 2 seconds on 4G connection
2. WHEN a booking is submitted, THE Maarg_Platform SHALL confirm the booking within 5 seconds
3. WHEN AI agents execute, THE Maarg_Platform SHALL return results within 3 seconds for 95% of requests
4. WHEN displaying maps, THE Passenger_App SHALL render location updates within 1 second
5. WHEN the system is under load (100 concurrent users), THE Maarg_Platform SHALL maintain response times within 10 seconds

### Requirement 15: Scalability

**User Story**: As a system administrator, I want the platform to scale efficiently, so that we can expand to more routes and cities.

#### Acceptance Criteria

1. WHEN the user base grows, THE Maarg_Platform SHALL support up to 500 concurrent drivers per city
2. WHEN processing bookings, THE Maarg_Platform SHALL handle up to 100 bookings per minute
3. WHEN storing trip data, THE Maarg_Platform SHALL efficiently store and query 100,000 trip records
4. WHEN adding new routes, THE Maarg_Platform SHALL onboard new routes without system downtime
5. WHEN scaling infrastructure, THE Maarg_Platform SHALL use auto-scaling AWS services to handle demand spikes

### Requirement 16: Reliability

**User Story**: As a user, I want the platform to be available and reliable, so that I can depend on it for daily commutes.

#### Acceptance Criteria

1. THE Maarg_Platform SHALL maintain 99% uptime during peak hours (7-10 AM, 5-8 PM)
2. WHEN a service component fails, THE Maarg_Platform SHALL failover to backup systems within 30 seconds
3. WHEN AI agents are unavailable, THE Maarg_Platform SHALL fallback to rule-based matching and routing
4. WHEN database queries fail, THE Maarg_Platform SHALL retry up to 3 times before returning an error
5. WHEN critical errors occur, THE Maarg_Platform SHALL alert administrators within 1 minute

### Requirement 17: Security and Privacy

**User Story**: As a user, I want my personal data protected, so that I can use the platform without privacy concerns.

#### Acceptance Criteria

1. WHEN storing user data, THE Maarg_Platform SHALL encrypt personally identifiable information at rest
2. WHEN transmitting data, THE Maarg_Platform SHALL use TLS 1.3 for all API communications
3. WHEN accessing user data, THE Maarg_Platform SHALL enforce role-based access control
4. WHEN collecting location data, THE Maarg_Platform SHALL retain precise location data for maximum 30 days
5. WHEN a user requests data deletion, THE Maarg_Platform SHALL permanently delete user data within 7 days

### Requirement 18: Accessibility

**User Story**: As a user with limited smartphone resources, I want the app to work on low-end devices, so that I can access the service.

#### Acceptance Criteria

1. THE Passenger_App SHALL run on Android devices with minimum 2 GB RAM and Android 8.0+
2. THE Driver_App SHALL run on Android devices with minimum 2 GB RAM and Android 8.0+
3. WHEN network is slow (2G/3G), THE Maarg_Platform SHALL compress data transfers to reduce bandwidth usage
4. WHEN displaying UI, THE Passenger_App SHALL use large touch targets (minimum 48x48 dp) for easy tapping
5. WHEN rendering text, THE Maarg_Platform SHALL support Hindi and English with clear, readable fonts (minimum 14sp)

### Requirement 19: Responsible AI

**User Story**: As a system administrator, I want AI decisions to be fair and transparent, so that users trust the platform.

#### Acceptance Criteria

1. WHEN the Dynamic_Pricing_Agent calculates fares, THE Maarg_Platform SHALL ensure pricing does not discriminate based on user demographics
2. WHEN the Route_Optimization_Agent suggests routes, THE Maarg_Platform SHALL provide explanations for route choices
3. WHEN AI predictions are uncertain (confidence below 70%), THE Maarg_Platform SHALL flag predictions for manual review
4. WHEN drivers or passengers dispute AI decisions, THE Maarg_Platform SHALL provide manual override capability
5. WHEN training AI models, THE Maarg_Platform SHALL audit training data for bias and fairness issues

## Dependencies and Constraints

### Technical Dependencies

- AWS services required: Amazon Bedrock (Claude 3.5 Sonnet), Amazon Q, API Gateway, Lambda, DynamoDB or RDS
- Kiro orchestration platform for AI agent coordination
- Supabase or AWS services for real-time database and authentication
- Mobile development: React Native or native Android (iOS optional for MVP)
- Mapping services: Google Maps API or OpenStreetMap

### Operational Constraints

- Initial deployment limited to 2-3 pilot routes in one city
- Driver onboarding requires in-person training sessions
- Passenger acquisition through local marketing and driver referrals
- Cash and UPI QR code payments (no payment gateway integration for MVP)
- Manual route configuration (no automated route discovery)

### Regulatory Constraints

- Compliance with Indian data protection regulations
- E-rickshaw operating licenses and permits required
- Driver background verification required
- Insurance coverage for shared mobility operations

## Success Metrics

### Driver Metrics

- Reduce empty trip kilometers by 30-40% within 3 months
- Increase average daily driver earnings by 25-35% within 3 months
- Achieve 70%+ AI suggestion acceptance rate by drivers
- Reduce driver idle time by 20% within 2 months

### Passenger Metrics

- Reduce average wait time from 15-20 minutes to under 5 minutes
- Achieve 60%+ voice booking adoption within 6 months
- Maintain 85%+ booking success rate (booking to completed trip)
- Achieve 4+ star average passenger satisfaction rating

### System Metrics

- Demand prediction accuracy: 75%+ within 30-minute windows
- Route optimization: 90%+ of suggested routes accepted by drivers
- Platform uptime: 99%+ during peak hours
- AI agent response time: 95% of requests under 3 seconds

### Business Metrics

- Onboard 50+ drivers across pilot routes within 3 months
- Complete 5,000+ trips within 6 months
- Achieve 40%+ week-over-week passenger growth in first 3 months
- Demonstrate clear ROI for drivers (earnings increase > platform costs)
