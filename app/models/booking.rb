class Booking < ApplicationRecord
  belongs_to :court
  belongs_to :user

  validates :court_id, uniqueness: { scope: [:date_time] }

  scope :filter_by_date, -> ( requested_date) { where(date_time:(requested_date.midnight)..(((requested_date + 1.day).midnight) - 1.second))}
  scope :filter_by_sport, -> ( sport) { joins(court: :sport).where( courts:{ sports: {name: sport}})}

# Get a list of booked slots
  def self.booked_slots( lookup_date, sport)
    bookings = Booking.filter_by_date( valid_date( lookup_date))
    bookings = bookings.filter_by_sport( sport) if sport
    bookings = bookings.select( :court_id, :date_time).map { |e| {court_id: e.court_id, date: e.date_time.to_date, time: e.date_time.hour} }

    bookings
  end

# Get a list of available slots
  def self.available_slots( lookup_date, sport)
    calculate_available_slots( valid_date( lookup_date), sport,
      booked_slots( lookup_date, sport))
  end

  private

  def self.calculate_available_slots( lookup_date, sport, bookings)
    # Get list of courts
    courts = Court.joins( :sport).includes( :sport)
    if sport
      courts = courts.where( sports:{name: sport})
    end
    courts = courts.select( :id, :name, :sport_id, :sport).order( :name)

    # Iterate through the courts list and get a list of avaiable slots and remove any booked slots
    slots = []
    courts.each do |court|
      court_slots = []
      daily_slots( lookup_date).each do |hour|
        slot = { court_id: court.id, date: lookup_date.to_date, time: hour}
        court_slots << slot unless bookings.include? slot
      end
      slots << { court: court, slots: court_slots}
    end

    slots
  end

# Get available slot list based on the lookup_date
# This could be expanded if the Openning hours are different based on the dates and the day of the week
  def self.daily_slots(lookup_date)
    (1..24)
  end

  def self.valid_date( date)
    date ? Date.parse( date) : Date.today
  end
end
